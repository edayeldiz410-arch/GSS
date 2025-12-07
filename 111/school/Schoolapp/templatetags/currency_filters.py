from django import template
import locale
from decimal import Decimal

register = template.Library()

@register.filter
def dzd(value):
    """Format Decimal as DZD currency with space thousands and comma decimals, suffix 'DZD'."""
    try:
        val = Decimal(value)
    except Exception:
        return value
    # Format with grouping and two decimals, using locale-independent approach
    sign = '-' if val < 0 else ''
    val = abs(val)
    q = f"{val:.2f}"
    parts = q.split('.')
    int_part = parts[0]
    dec_part = parts[1]
    # group thousands with space
    int_part_grouped = ''
    while int_part:
        int_part_grouped = (int_part[-3:] + (' ' if int_part_grouped else '') + int_part_grouped) if int_part_grouped or len(int_part) <= 3 else (int_part[-3:] + (' ' if int_part_grouped else '') + int_part_grouped)
        int_part = int_part[:-3]
    if not int_part_grouped:
        int_part_grouped = '0'
    return f"{sign}{int_part_grouped},{dec_part} DZD"


@register.filter
def signed(value, places=2):
    """Return a string with explicit + or - and formatted number with given decimal places (no currency suffix).

    Examples:
      10 -> "+10.00"
      -5 -> "-5.00"
      0 -> "0.00"
    """
    try:
        v = float(value)
    except Exception:
        return value
    fmt = f"{{:.{int(places)}f}}"
    # Display convention: positive balance (student owes) -> show '-' prefix
    # negative balance (overpaid / credit) -> show '+' prefix
    if abs(v) < 10 ** (-int(places) - 1):
        return fmt.format(0)
    if v > 0:
        return f"-{fmt.format(v)}"
    # v < 0
    return f"+{fmt.format(abs(v))}"


@register.filter
def balance_for_student(value, places=2):
    """Format balance for the students list per UI rules:
    - zero -> return the literal 'Réglé' (no currency)
    - non-zero -> return absolute amount formatted with DZD suffix (no leading sign)

    This keeps the numeric semantics consistent with the payments page (server provides
    signed values), but the students table shows the absolute value and uses CSS classes
    (via balance_class) to indicate state (soldé / crédité / réglé).
    """
    try:
        v = Decimal(value)
    except Exception:
        return "0,00 DZD"
    # treat very small values as zero
    if abs(v) < (Decimal(1) / (Decimal(10) ** (int(places) + 1))):
        return "Réglé"
    # use existing dzd formatter on the absolute value to keep grouping and decimals
    return dzd(abs(v))


@register.filter
def balance_class(value):
    """Return a css class name for a balance value:
    - 'balance-regle' when zero
    - 'balance-solde' when > 0 (soldé)
    - 'balance-credite' when < 0 (crédit)
    """
    try:
        v = float(value)
    except Exception:
        return ''
    if abs(v) < 0.005:
        return 'balance-regle'
    if v > 0:
        return 'balance-solde'
    return 'balance-credite'


@register.filter
def format_space(value, places=2):
    """Format a number grouping thousands with space and remove trailing zeros.

    Examples:
      22000.00 -> '22 000'
      47000.50 -> '47 000,5'
      1234.56  -> '1 234,56'
    Returns the original value on error.
    """
    try:
        v = Decimal(value)
    except Exception:
        return value
    # treat very small values as zero
    # normalize to given decimal places then strip trailing zeros
    q = f"{v:.{int(places)}f}"
    # use comma as decimal separator like dzd
    if '.' in q:
        int_part, dec_part = q.split('.')
    else:
        int_part, dec_part = q, ''
    # group thousands with space
    ip = int_part
    sign = ''
    if ip.startswith('-'):
        sign = '-'
        ip = ip[1:]
    grouped = ''
    while ip:
        grouped = (ip[-3:] + (' ' + grouped if grouped else '')) if grouped or len(ip) <= 3 else (ip[-3:] + (' ' + grouped if grouped else ''))
        ip = ip[:-3]
    if not grouped:
        grouped = '0'
    # remove trailing zeros from decimal part
    dec_part = dec_part.rstrip('0')
    if dec_part:
        return f"{sign}{grouped},{dec_part}"
    return f"{sign}{grouped}"


@register.filter
def signed_space(value, places=2):
    """Like `signed` but format the magnitude with spaces and remove trailing zeros.

    Keeps the same sign convention as `signed`:
      positive -> prefix '-' (student owes)
      negative -> prefix '+' (credit)
    """
    try:
        v = Decimal(value)
    except Exception:
        return value
    # treat very small values as zero
    if abs(v) < (Decimal(1) / (Decimal(10) ** (int(places) + 1))):
        fmt = f"{{:.{int(places)}f}}"
        return fmt.format(0)
    # Determine sign according to existing `signed` convention
    if v > 0:
        prefix = '-'
        mag = v
    else:
        prefix = '+'
        mag = abs(v)
    # format magnitude using format_space (without suffix)
    mag_str = format_space(mag, places=places)
    return f"{prefix}{mag_str}"
