#!/usr/bin/env python3

import csv
import sys
from collections import Counter
from pathlib import Path
from typing import TypeAlias

Row: TypeAlias = dict[str, str]
RawRow: TypeAlias = dict[str, str | None]

FIELDS: list[str, ...] = ["ID", "Sentence", "Target Word", "Translation"]


def clean_text(text: str | None) -> str:
    """Strip whitespace and rejoin text with a space"""
    if text is None:
        return ""

    text = text.strip()
    text = " ".join(text.split())
    return text


def read_rows(path: Path) -> list[RawRow]:
    """Read in rows from the csv"""
    with path.open(newline="", encoding="utf-8-sig") as file:
        reader = csv.DictReader(file)
        rows = list(reader)
        fieldnames = reader.fieldnames

    # Add guard in case the columns are not per expectation
    if fieldnames != FIELDS:
        raise SystemExit(f"Expected columns: {FIELDS}\nGot: {fieldnames}")

    return rows


def clean_rows(raw_rows: list[RawRow]) -> list[Row]:
    """Normalize required field whitespace, validate non-empty values, and return cleaned rows for duplicate checks and writing."""
    # Instantiate cleaned rows
    cleaned_rows = []

    for row_num, row in enumerate(raw_rows, start=2):  # Row 1 is the CSV header.
        row = {field: clean_text(row[field]) for field in FIELDS}
        missing_fields = [field for field, value in row.items() if not value]
        if missing_fields:
            raise SystemExit(f"Row {row_num} missing: {', '.join(missing_fields)}")
        cleaned_rows.append(row)

    return cleaned_rows


def check_duplicate_ids(rows: list[Row]) -> None:
    """Check if any ID appears more than once and throw an error"""
    seen = {}

    for row_num, row in enumerate(raw_rows, start=2):
        key = row["ID"]

        if key in seen:
            first_row = seen[key]
            raise SystemExit(
                f"Duplicate ID found: {id_value}\n- First seen on row {first_row}\n- Repeated on row {row_num}"
            )

    seen[id_value] = row_num


def check_duplicate_cards(rows: list[Row]) -> None:
    """Stop if the same Sentence + Target Word appears more than once."""

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
    """Write the cleaned CSV that will be imported into Anki."""

    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Convert a Google Sheet CSV export into a validated Anki import CSV."""

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
