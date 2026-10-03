#!/usr/bin/env python3
# Copyright (c) 2026 AmirHesam Tech. All rights reserved. See LICENSE.md.
"""
Run every answer in practice/chinook.sql and practice/employees.sql against the
real databases and compare what comes back with the "-- Result:" line under it.

    python tools/check_answers.py

By default it looks for the two database files in the "databases" folder:

    databases/Chinook_Sqlite.sqlite
    databases/employees_db-full-1.0.6.db

If yours are somewhere else, tell it where:

    python tools/check_answers.py --chinook path/to/Chinook_Sqlite.sqlite \
                                  --employees path/to/employees_db-full-1.0.6.db

Only the Python standard library is used. Nothing is written to the databases:
they are opened read-only.
"""
import argparse
import os
import re
import sqlite3
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
QUESTION = re.compile(r"^-- Q(\d+)\. ")


def fmt_val(value):
    if value is None:
        return "NULL"
    text = str(value)
    return text if len(text) <= 44 else text[:41] + "..."


def fmt_row(row, maxlen=64):
    parts = [fmt_val(v) for v in row]
    text = " | ".join(parts)
    if len(text) <= maxlen:
        return text
    keep = []
    for part in parts:
        if len(" | ".join(keep + [part])) > maxlen - 6:
            break
        keep.append(part)
    return " | ".join(keep) + " | ..."


def summarize(columns, rows):
    """The same one-line summary that is written after each answer."""
    if not rows:
        return "0 rows"
    if len(rows) == 1 and len(columns) == 1:
        return fmt_val(rows[0][0])
    if len(rows) == 1:
        return "1 row: " + fmt_row(rows[0])
    return "%d rows. First row: %s" % (len(rows), fmt_row(rows[0]))


def read_answers(path):
    """Yield (question number, sql, expected result line) for one .sql file."""
    with open(path, encoding="utf-8") as handle:
        lines = handle.read().splitlines()
    i = 0
    while i < len(lines):
        match = QUESTION.match(lines[i])
        if not match:
            i += 1
            continue
        number = int(match.group(1))
        i += 1
        while i < len(lines) and lines[i].startswith("--"):  # rest of the question text
            i += 1
        sql = []
        while i < len(lines):
            sql.append(lines[i])
            i += 1
            if sql[-1].rstrip().endswith(";"):
                break
        expected = None
        if i < len(lines) and lines[i].startswith("-- Result: "):
            expected = lines[i][len("-- Result: "):]
        yield number, "\n".join(sql), expected


def check(label, sql_file, db_file):
    if not os.path.exists(db_file):
        print("%-10s SKIPPED - database not found: %s" % (label, db_file))
        return None
    con = sqlite3.connect("file:%s?mode=ro" % db_file.replace("\\", "/"), uri=True)
    passed = failed = 0
    started = time.time()
    for number, sql, expected in read_answers(sql_file):
        try:
            cursor = con.execute(sql.strip().rstrip(";"))
            rows = cursor.fetchall()
            got = summarize([d[0] for d in cursor.description], rows)
        except sqlite3.Error as error:
            got = "ERROR: %s" % error
        if got == expected:
            passed += 1
        else:
            failed += 1
            print("%s Q%d DOES NOT MATCH\n   expected: %s\n   got:      %s" % (label, number, expected, got))
    con.close()
    print("%-10s %d of %d answers match  (%.1f s)" % (label, passed, passed + failed, time.time() - started))
    return failed == 0


def main():
    parser = argparse.ArgumentParser(description="Check every answer against the real databases.")
    parser.add_argument("--chinook", default=os.path.join(ROOT, "databases", "Chinook_Sqlite.sqlite"))
    parser.add_argument("--employees", default=os.path.join(ROOT, "databases", "employees_db-full-1.0.6.db"))
    args = parser.parse_args()

    if sqlite3.sqlite_version_info < (3, 25, 0):
        sys.exit("Your Python ships SQLite %s. The window-function questions need 3.25 or newer."
                 % sqlite3.sqlite_version)

    print("SQLite %s\n" % sqlite3.sqlite_version)
    results = [
        check("Chinook", os.path.join(ROOT, "practice", "chinook.sql"), args.chinook),
        check("Employees", os.path.join(ROOT, "practice", "employees.sql"), args.employees),
    ]
    if any(r is False for r in results):
        sys.exit(1)
    if all(r is None for r in results):
        sys.exit("\nNo database found. Download them from the Releases page and unzip them into the "
                 "'databases' folder.")


if __name__ == "__main__":
    main()
