# Data: daily prices of Bank Mellat (symbol «وبملت»)

Source: Tehran Securities Exchange Technology Management Co. – <http://www.tsetmc.com>
(instrument page of the symbol; use the "export history" / daily price download).
The report used daily data from 2015-01-03 to 2025 (2464 trading days).

Save the file as `data/melat.csv` (or set `MELAT_CSV=/path/to/file.csv`).

Required columns (header names are cleaned automatically, so `<LAST>` or `last` both work):

| Column | Meaning |
|---|---|
| `Date` (or `<DTYYYYMMDD>`) | date, either `20150103` or `2015-01-03` |
| `FIRST`, `HIGH`, `LOW`, `CLOSE`, `OPEN`, `LAST` | prices (`LAST` = last traded price, the analysed series) |
| `VALUE`, `VOL`, `OPENINT` | traded value, volume, open interest |

Extra columns (e.g. ticker, period) are ignored. The CSV is not committed to git
(see `.gitignore`); if you want to share it, remove the corresponding line in
`.gitignore` after checking the exchange's terms of use.
