CREATE USER testuser PASSWORD 'test';
DROP USER testuser;

CREATE ROLE reader;
GRANT SELECT ON vysledky_zavodu TO reader;
REVOKE SELECT ON vysledky_zavodu FROM reader;

GRANT reader TO testuser;
REVOKE reader FROM testuser;

DROP ROLE reader;