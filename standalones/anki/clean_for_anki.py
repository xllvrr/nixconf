#!/usr/bin/env python3

import csv
import sys
from collections import Counter
from pathlib import Path
from typing import TypeAlias

Row: TypeAlias = dict[str, str]
RawRow: TypeAlias = dict[str, str | None]

# Schema field order is intentional: we validate incoming CSV headers in this
# exact order and use the same order when writing output for deterministic
# imports.
FIELDS: tuple[str, ...] = ("ID", "Sentence", "Target Word", "Translation")


def clean_text(text: str | None) -> str:
    """Normalize cell text so Anki imports stable, space-collapsed values."""
    if text is None:
        return ""

    text = text.strip()
    text = " ".join(text.split())
    return text


def read_rows(path: Path) -> list[RawRow]:
    """Read CSV rows and stop if headers differ from the required Anki schema."""
    with path.open(newline="", encoding="utf-8-sig") as file:  # Handles optional UTF-8 BOM from spreadsheet exports.
        reader = csv.DictReader(file)
        rows = list(reader)
        fieldnames = reader.fieldnames

    # Guard against schema drift: both field names and field order are part of
    # validation expectations.
    if tuple(fieldnames or ()) != FIELDS:
        raise SystemExit(f"Expected columns: {FIELDS}\nGot: {fieldnames}")

    return rows

def clean_rows(raw_rows: RawRow) -> Row:
    """Clean each row and raise SystemExit when any required field is blank."""
    cleaned_rows = []

    for row_num, row in enumerate(raw_rows, start=2):  # Start at 2 because row 1 is the CSV header.
        row = {field: clean_text(raw_rows[field]) for field in FIELDS}
        missing_fields = [field for field, value in row.items() if not value]
        if missing_fields:
            raise SystemExit(f"Row {row_num} missing: {', '.join(missing_fields)}")
        cleaned_rows.append(row)

    return cleaned_rows


def check_duplicate_ids(rows: list[Row]) -> None:
    """Raise SystemExit if a card ID repeats, reporting both conflicting row numbers."""
    seen = {}

    # Row numbering starts at 2 because row 1 is the CSV header.
    for row_num, row in enumerate(rows, start=2):
        key = row["ID"]

        if key in seen:
            first_row = seen[key]
            raise SystemExit(
                f"Duplicate ID found: {key}\n- First seen on row {first_row}\n- Repeated on row {row_num}"
            )

        seen[key] = row_num


def check_duplicate_cards(rows: list[Row]) -> None:
    """Raise SystemExit when Sentence + Target Word duplicates would create duplicate notes."""

    seen = {}

    for row_number, row in enumerate(rows, start=2):
        key = (row["Sentence"], row["Target Word"])

        if key in seen:
            first_row = seen[key]
            sentence, target_word = key

            raise SystemExit(
                "Duplicate Sentence + Target Word found:\n"
                f"- First seen on row {first_row}\n"
                f"- Repeated on row {row_number}\n"
                f"- Sentence: {sentence}\n"
                f"- Target Word: {target_word}"
            )

        seen[key] = row_number


def write_rows(path: Path, rows: list[Row]) -> None:
    """Write validated rows to the final CSV in Anki-ready column order."""

    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Run CSV cleanup workflow and raise SystemExit on bad args or validation failures."""

    if len(sys.argv) != 3:
        raise SystemExit("Usage: clean_for_anki.py sheet_raw.csv anki_import.csv")

    raw_csv: Path = Path(sys.argv[1])
    anki_csv: Path = Path(sys.argv[2])

    raw_rows: list[RawRow] = read_rows(raw_csv)
    rows: list[Row] = clean_rows(raw_rows)

    check_duplicate_ids(rows)
    check_duplicate_cards(rows)
    write_rows(anki_csv, rows)

    print(f"Wrote {anki_csv}: {len(rows)} rows")


if __name__ == "__main__":
    main()
