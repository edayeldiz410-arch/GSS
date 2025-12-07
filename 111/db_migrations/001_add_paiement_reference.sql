-- Migration: Add `reference` column to `paiement` and populate it with RET-prefixed values
-- Safe steps: add nullable column, populate existing rows, make NOT NULL + unique, add trigger for future inserts

START TRANSACTION;

-- 1) Add nullable column
ALTER TABLE paiement
  ADD COLUMN `reference` VARCHAR(64) NULL;

-- 2) Populate existing rows with RET + id (zero-padded if desired)
UPDATE paiement
  SET `reference` = CONCAT('RET', id);

-- 3) Make column NOT NULL (only if all rows populated) and add unique index
ALTER TABLE paiement
  MODIFY COLUMN `reference` VARCHAR(64) NOT NULL,
  ADD UNIQUE INDEX ux_paiement_reference (`reference`);

-- 4) Create AFTER INSERT trigger to populate reference for future inserts (if not provided)
DELIMITER $$
CREATE TRIGGER paiement_set_reference AFTER INSERT ON paiement
FOR EACH ROW
BEGIN
  IF NEW.reference IS NULL OR NEW.reference = '' THEN
    UPDATE paiement SET `reference` = CONCAT('RET', NEW.id) WHERE id = NEW.id;
  END IF;
END$$
DELIMITER ;

COMMIT;

-- Notes:
-- - This SQL assumes the table name is `paiement` (as in your models' db_table). Adjust if different.
-- - If you'd prefer a formatted reference like RET000123, replace CONCAT('RET', id) with CONCAT('RET', LPAD(id,6,'0')).
-- - If your MySQL version supports generated stored columns and you prefer that approach, you can instead use:
--   ALTER TABLE paiement ADD COLUMN `reference` VARCHAR(64) GENERATED ALWAYS AS (CONCAT('RET', id)) STORED, ADD UNIQUE INDEX ux_paiement_reference (`reference`);
-- - Run this file against your database (see instructions below).
