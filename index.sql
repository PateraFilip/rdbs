DROP INDEX vysledek_pilota;

CREATE UNIQUE INDEX vysledek_pilota
ON vysledky_zavodu (id_pilota, id_zavodu);

INSERT INTO vysledky_zavodu (id_vysledku, id_pilota, id_zavodu, pozice_v_cili, id_statusu)
VALUES (211, 1, 3, 4, 1);