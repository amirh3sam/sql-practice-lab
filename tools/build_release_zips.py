#!/usr/bin/env python3
# Copyright (c) 2026 AmirHesam Tech. All rights reserved. See LICENSE.md.
"""
Build the two download ZIPs for the GitHub Releases page.

    python tools/build_release_zips.py

Each ZIP holds one database together with its license and its credits, so the
attribution always travels with the file:

    dist/chinook-sqlite.zip
        Chinook_Sqlite.sqlite
        Chinook-LICENSE.txt
        Chinook-CREDITS.txt

    dist/employees-sqlite.zip
        employees_db-full-1.0.6.db
        Employees-LICENSE.txt
        Employees-CREDITS.txt

The script refuses to pack a database whose SHA-256 checksum does not match the
original file, so a changed database can never be shipped by accident under the
"no changes" credit.

By default it looks for the databases in the "databases" folder. If yours are
somewhere else:

    python tools/build_release_zips.py --chinook path/to/Chinook_Sqlite.sqlite \
                                       --employees path/to/employees_db-full-1.0.6.db

Only the Python standard library is used.
"""
import argparse
import hashlib
import os
import sys
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LICENSES = os.path.join(ROOT, "licenses")

PACKAGES = {
    "chinook": {
        "zip": "chinook-sqlite.zip",
        "database": "Chinook_Sqlite.sqlite",
        "sha256": "bdf635be69850bd3be09c9a2dbeef7ddfb80036bd3ef3381383cd03b61e4a61a",
        "extras": [("Chinook-LICENSE.md", "Chinook-LICENSE.txt"),
                   ("Chinook-CREDITS.txt", "Chinook-CREDITS.txt")],
    },
    "employees": {
        "zip": "employees-sqlite.zip",
        "database": "employees_db-full-1.0.6.db",
        "sha256": "1c922847de40d6b68b4db0e18a467656fe92e2e221915f2b16fa08bee0ed2b6f",
        "extras": [("Employees-LICENSE-CC-BY-SA-3.0.txt", "Employees-LICENSE.txt"),
                   ("Employees-CREDITS.txt", "Employees-CREDITS.txt")],
    },
}


def sha256(path):
    digest = hashlib.sha256()
    with open(path, "rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build(name, database_path, out_dir):
    package = PACKAGES[name]
    if not os.path.exists(database_path):
        print("%-10s SKIPPED - database not found: %s" % (name, database_path))
        return None

    found = sha256(database_path)
    if found != package["sha256"]:
        print("%-10s STOPPED - this is not the original file.\n"
              "           expected SHA-256 %s\n"
              "           found    SHA-256 %s\n"
              "           Download a fresh copy before packing it." % (name, package["sha256"], found))
        return False

    os.makedirs(out_dir, exist_ok=True)
    zip_path = os.path.join(out_dir, package["zip"])
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        archive.write(database_path, package["database"])
        for source, name_in_zip in package["extras"]:
            archive.write(os.path.join(LICENSES, source), name_in_zip)

    with zipfile.ZipFile(zip_path) as archive:
        problem = archive.testzip()
        if problem:
            print("%-10s FAILED - the ZIP is damaged at %s" % (name, problem))
            return False
        contents = ", ".join(archive.namelist())

    print("%-10s OK  %s  (%.1f MB)\n           contains: %s"
          % (name, os.path.relpath(zip_path, ROOT), os.path.getsize(zip_path) / 1e6, contents))
    return True


def main():
    parser = argparse.ArgumentParser(description="Build the two database ZIPs for GitHub Releases.")
    parser.add_argument("--chinook", default=os.path.join(ROOT, "databases", "Chinook_Sqlite.sqlite"))
    parser.add_argument("--employees", default=os.path.join(ROOT, "databases", "employees_db-full-1.0.6.db"))
    parser.add_argument("--out", default=os.path.join(ROOT, "dist"), help="folder for the ZIPs (default: dist)")
    args = parser.parse_args()

    results = [build("chinook", args.chinook, args.out),
               build("employees", args.employees, args.out)]
    if any(result is False for result in results):
        sys.exit(1)
    if all(result is None for result in results):
        sys.exit("\nNo database found. Put the two files in the 'databases' folder, "
                 "or pass --chinook and --employees.")


if __name__ == "__main__":
    main()
