CREATE OR REPLACE PROCEDURE vytvor_tabulku_s_casy()
LANGUAGE plpgsql
AS $$
DECLARE
    cur CURSOR FOR
        SELECT o.id_okruhu, o.nazev, MIN(v.cas_nejrychlejsiho_kola) AS nejrychlejsi_cas
        FROM okruhy o
        JOIN zavody z ON o.id_okruhu = z.id_okruhu
        JOIN vysledky_zavodu v ON z.id_zavodu = v.id_zavodu
        GROUP BY o.id_okruhu, o.nazev;

    v_id_okruhu INT;
    v_nazev_okruhu VARCHAR(255);
    v_nejrychlejsi_cas TIME;
    
BEGIN
    BEGIN
        CREATE TABLE IF NOT EXISTS tabulka_s_casy (
            id_okruhu INT,
            nazev_okruhu VARCHAR(255),
            nejrychlejsi_cas TIME
        );

        OPEN cur;
        
        LOOP
            FETCH cur INTO v_id_okruhu, v_nazev_okruhu, v_nejrychlejsi_cas;
            
            EXIT WHEN NOT FOUND;

            INSERT INTO tabulka_s_casy (id_okruhu, nazev_okruhu, nejrychlejsi_cas)
            VALUES (v_id_okruhu, v_nazev_okruhu, v_nejrychlejsi_cas);
        END LOOP;
        
        CLOSE cur;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Chyba: %', SQLERRM;
            ROLLBACK;
    END;
    
END;
$$;

CALL vytvor_tabulku_s_casy();
