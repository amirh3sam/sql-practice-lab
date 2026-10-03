# Licenses and credits

SQL Practice Lab re-shares two sample databases that other people made and kindly published under open licenses. This page says exactly what is shared, who made it, where it came from, and what you may do with it.

Thank you to everyone named here.

## At a glance

| | Chinook | Employees |
|---|---|---|
| **What it is** | Sample database of a digital music store | Sample database of a company's HR records |
| **File** | `Chinook_Sqlite.sqlite` | `employees_db-full-1.0.6.db` |
| **Version** | 1.4.5 | 1.0.6 |
| **License** | [MIT License](Chinook-LICENSE.md) | [Creative Commons Attribution-ShareAlike 3.0 Unported](Employees-LICENSE-CC-BY-SA-3.0.txt) (CC BY-SA 3.0) |
| **Source** | [lerocha/chinook-database](https://github.com/lerocha/chinook-database) | [fracpete/employees-db-sqlite](https://github.com/fracpete/employees-db-sqlite), a SQLite port of [datacharmer/test_db](https://github.com/datacharmer/test_db) |
| **Changes made here** | None | None to the database (see below) |

## Chinook Database

- **Author and copyright:** Copyright (c) 2008-2024 Luis Rocha
- **License:** MIT License. The full, original text is in [Chinook-LICENSE.md](Chinook-LICENSE.md).
- **Source:** <https://github.com/lerocha/chinook-database>
- **Exact file:** `Chinook_Sqlite.sqlite` from the official [v1.4.5 release](https://github.com/lerocha/chinook-database/releases/tag/v1.4.5)
- **Changes:** none. The file shared here is byte-for-byte identical to the official release file.
- **SHA-256:** `bdf635be69850bd3be09c9a2dbeef7ddfb80036bd3ef3381383cd03b61e4a61a`

## Employees sample database (SQLite port)

- **Original data:** Fusheng Wang and Carlo Zaniolo, Siemens Corporate Research ([timecenter.cs.aau.dk](https://web.archive.org/web/20220120205430/http://timecenter.cs.aau.dk/software.htm))
- **Relational schema:** Giuseppe Maxia
- **Relational export:** Patrick Crews
- **MySQL version ("test_db"):** <https://github.com/datacharmer/test_db>
- **SQLite port:** Peter Reutemann ([fracpete](https://github.com/fracpete)), made with [mysql2sqlite](https://github.com/dumblob/mysql2sqlite): <https://github.com/fracpete/employees-db-sqlite>
- **License:** Creative Commons Attribution-ShareAlike 3.0 Unported, <https://creativecommons.org/licenses/by-sa/3.0/>. The full legal text is in [Employees-LICENSE-CC-BY-SA-3.0.txt](Employees-LICENSE-CC-BY-SA-3.0.txt).
- **Exact file:** `employees_db-full-1.0.6.db`, extracted from [`employees_db-full-1.0.6.db.gz`](https://raw.githubusercontent.com/fracpete/employees-db-sqlite/master/employees_db-full-1.0.6.db.gz)
- **Changes:** nothing inside the database was changed. The original download is a `.gz` archive. Here the same file was extracted and packed into a `.zip`, next to its license and credits.
- **SHA-256 of the database file:** `1c922847de40d6b68b4db0e18a467656fe92e2e221915f2b16fa08bee0ed2b6f`
- **SHA-256 of the original `.gz` archive:** `be11573563410accba53381af781b674c44f51f55b782e1c3e447c85d5a3beca`

Disclaimer from the original authors:

> To the best of my knowledge, this data is fabricated and it does not correspond to real people. Any similarity to existing people is purely coincidental.

### If you share the Employees database yourself

In plain words, CC BY-SA 3.0 lets you copy, share and change the database, as long as you:

1. **Give credit** to the people listed above.
2. **Link to the license** and **say what you changed**.
3. **Share alike:** if you publish a changed version, publish it under the same license (CC BY-SA 3.0), a later version of it, or a compatible license.

This is only a summary. The [license text](Employees-LICENSE-CC-BY-SA-3.0.txt) is what counts.

## Everything else in this repository

The practice questions, answers, guides, pictures and scripts were written for SQL Practice Lab. Copyright (c) 2026 AmirHesam Tech. All rights reserved. You may use them for your own learning. Republishing them elsewhere needs permission. The terms are in [LICENSE.md](../LICENSE.md).

Two small notes:

- A few lines in this repository quote data from the databases, for example the `-- Result:` lines in the practice files and the tables shown in the pictures. Those excerpts stay under the license of the database they come from (MIT for Chinook, CC BY-SA 3.0 for Employees).
- The screenshots show [DBeaver Community](https://dbeaver.io/) 26.2.1, which is open source software under the Apache License 2.0.

## No endorsement

SQL Practice Lab is an independent learning project. It is not affiliated with, sponsored by, or endorsed by Luis Rocha, the authors of the Employees database, DBeaver Corp, or the SQLite project. All product names and trademarks belong to their owners.

## Something missing or wrong?

If you are one of the authors and want a credit changed, or you spot a mistake on this page, please [open an issue](https://github.com/hesamworkshop/sql-practice-lab/issues). It will be fixed quickly.
