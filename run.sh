test -f db && rm db

sqlite3 db < insert.sql

sqlite3 db < select.sql
