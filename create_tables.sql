CREATE TABLE IF NOT EXISTS dodavatele_motoru (
    id_dodavatele_motoru SERIAL PRIMARY KEY,
    nazev VARCHAR(50) NOT NULL
);

INSERT INTO dodavatele_motoru (id_dodavatele_motoru, nazev) VALUES
    (1, 'Ferrari'),
    (2, 'Honda RBPT'),
    (3, 'Mercedes'),
    (4, 'Renault');
