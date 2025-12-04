-- Migration: enhance `paiement` table for richer payment tracking
-- Adds: inscription_id FK, balance_after snapshot, created_at/updated_at, unique reference, indexes
-- Backfills existing rows and creates triggers to maintain reference and balance_after

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;

-- 1) Add new columns if they do not exist
ALTER TABLE `paiement`
  ADD COLUMN IF NOT EXISTS `inscription_id` int UNSIGNED NULL AFTER `formation_id`,
  ADD COLUMN IF NOT EXISTS `reference` varchar(100) DEFAULT NULL AFTER `statut`,
  ADD COLUMN IF NOT EXISTS `balance_after` decimal(10,2) DEFAULT NULL AFTER `montant`,
  ADD COLUMN IF NOT EXISTS `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `remarques`,
  ADD COLUMN IF NOT EXISTS `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;

-- 2) Indexes and foreign keys
ALTER TABLE `paiement`
  ADD INDEX IF NOT EXISTS `idx_paiement_inscription` (`inscription_id`),
  ADD UNIQUE INDEX IF NOT EXISTS `ux_paiement_reference` (`reference`(100));

-- Add FK to `inscription` if that table exists in the schema
-- Use ON DELETE SET NULL so historical payments remain but loose the link when inscription removed
ALTER TABLE `paiement`
  ADD CONSTRAINT IF NOT EXISTS `fk_paiement_inscription` FOREIGN KEY (`inscription_id`) REFERENCES `inscription` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- 3) Backfill reference for existing rows (RET + zero-padded id)
UPDATE `paiement` p
SET p.reference = CONCAT('RET', LPAD(p.id, 6, '0'))
WHERE p.reference IS NULL OR p.reference = '';

-- 4) Backfill balance_after for existing payments.
-- balance_after should be: total_due_for_student - cumulative_paid_up_to_and_including_this_payment
-- total_due_for_student is computed by summing inscription.prix_total for all inscriptions of the etudiant
-- If your schema uses a different column for inscription total, adjust below.
UPDATE `paiement` p
SET p.balance_after = (
  (SELECT COALESCE(SUM(i.prix_total),0) FROM `inscription` i WHERE i.etudiant_id = p.etudiant_id)
  - (
      SELECT COALESCE(SUM(p2.montant),0) FROM `paiement` p2
      WHERE p2.etudiant_id = p.etudiant_id
        AND (p2.date_paiement < p.date_paiement OR (p2.date_paiement = p.date_paiement AND p2.id <= p.id))
    )
)
WHERE 1=1;

-- 5) Create triggers to maintain reference and balance_after on INSERT and UPDATE
-- Remove existing triggers if present (safe-guard)
DROP TRIGGER IF EXISTS `tr_paiement_after_insert`;
DROP TRIGGER IF EXISTS `tr_paiement_after_update`;

DELIMITER $$
CREATE TRIGGER `tr_paiement_after_insert`
AFTER INSERT ON `paiement`
FOR EACH ROW
BEGIN
  DECLARE total_due DECIMAL(10,2) DEFAULT 0;
  DECLARE paid_before DECIMAL(10,2) DEFAULT 0;

  -- compute total amount due across all inscriptions for this student
  SELECT COALESCE(SUM(i.prix_total),0) INTO total_due FROM `inscription` i WHERE i.etudiant_id = NEW.etudiant_id;

  -- compute cumulative paid up to and including the new payment
  SELECT COALESCE(SUM(p2.montant),0) INTO paid_before
  FROM `paiement` p2
  WHERE p2.etudiant_id = NEW.etudiant_id
    AND (p2.date_paiement < NEW.date_paiement OR (p2.date_paiement = NEW.date_paiement AND p2.id <= NEW.id));

  -- set reference if missing, and update balance_after snapshot for this payment
  UPDATE `paiement` SET
    `reference` = IFNULL(NEW.reference, CONCAT('RET', LPAD(NEW.id,6,'0'))),
    `balance_after` = total_due - paid_before
  WHERE id = NEW.id;
END$$

CREATE TRIGGER `tr_paiement_after_update`
AFTER UPDATE ON `paiement`
FOR EACH ROW
BEGIN
  DECLARE etu INT UNSIGNED;
  SET etu = NEW.etudiant_id;

  -- If montant, date_paiement or etudiant_id changed, recompute balance_after for all payments of that student
  -- We recompute using a derived subquery per-payment to ensure correct running totals.
  UPDATE `paiement` p
  JOIN (
    SELECT p1.id AS pid,
      (
        (SELECT COALESCE(SUM(i.prix_total),0) FROM `inscription` i WHERE i.etudiant_id = p1.etudiant_id)
        - (SELECT COALESCE(SUM(p2.montant),0) FROM `paiement` p2
           WHERE p2.etudiant_id = p1.etudiant_id
             AND (p2.date_paiement < p1.date_paiement OR (p2.date_paiement = p1.date_paiement AND p2.id <= p1.id)))
      ) AS new_balance
    FROM `paiement` p1
    WHERE p1.etudiant_id = etu
  ) calc ON p.id = calc.pid
  SET p.balance_after = calc.new_balance;
END$$
DELIMITER ;

COMMIT;

-- Notes:
-- - This migration stores a snapshot `balance_after` for each payment to make displaying the "solde" fast.
-- - The triggers update the single payment's snapshot on INSERT and recompute all payments for the student on UPDATE.
-- - For large datasets the UPDATE in the triggers can be expensive; an alternative is to compute balances on read via queries.
-- - Make a DB backup before running this migration. Adjust column names (e.g., `inscription.prix_total`) if your schema uses different names.
