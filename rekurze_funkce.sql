CREATE OR REPLACE FUNCTION vysledek_zavodu(id_zavodu_param INT)
RETURNS TABLE (
    id_zavodu INT,
    pozice_v_cili INT,
    cislo_pilota INT,
    jmeno_pilota TEXT,
    tym TEXT,
    pocet_odjetych_kol INT,
    cas TIME,
    ztrata_na_prvniho TEXT,
    ztrata_na_dalsi_pozici TEXT,
    cas_nejrychlejsiho_kola TIME
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE ztraty AS (
        SELECT 
            v.id_zavodu,
            v.pozice_v_cili,
            v.id_pilota,
            v.pocet_odjetych_kol,
            v.cas,
            NULL::text AS casova_ztrata
        FROM vysledky_zavodu v
        WHERE v.id_zavodu = id_zavodu_param AND v.pozice_v_cili = 1

        UNION ALL

        SELECT 
            v.id_zavodu,
            v.pozice_v_cili,
            v.id_pilota,
            v.pocet_odjetych_kol,
            v.cas,
            CASE
                WHEN v.pocet_odjetych_kol = z.pocet_odjetych_kol THEN (v.cas - z.cas)::text
                WHEN v.pocet_odjetych_kol < z.pocet_odjetych_kol THEN 
                    '+' || (z.pocet_odjetych_kol - v.pocet_odjetych_kol)::text || ' kolo'
                ELSE NULL
            END AS casova_ztrata
        FROM vysledky_zavodu v
        JOIN ztraty z
          ON v.id_zavodu = z.id_zavodu AND v.pozice_v_cili = z.pozice_v_cili + 1
    )
    SELECT 
        v.id_zavodu,
        v.pozice_v_cili,
        p.cislo_pilota,
        p.jmeno || ' ' || p.prijmeni AS jmeno_pilota,
        t.nazev,
        v.pocet_odjetych_kol,
        v.cas,
        CASE
            WHEN v.pocet_odjetych_kol < (SELECT vz.pocet_odjetych_kol FROM vysledky_zavodu vz WHERE vz.pozice_v_cili = 1 AND vz.id_zavodu = id_zavodu_param) AND v.pozice_v_cili IS NOT NULL
            THEN '+' || ((SELECT vz.pocet_odjetych_kol FROM vysledky_zavodu vz WHERE vz.pozice_v_cili = 1 AND vz.id_zavodu = id_zavodu_param) - v.pocet_odjetych_kol)::text || ' kolo'
            WHEN v.pozice_v_cili IS NULL
            THEN s.status
            ELSE (v.cas - (SELECT vz.cas FROM vysledky_zavodu vz WHERE vz.pozice_v_cili = 1 AND vz.id_zavodu = id_zavodu_param))::text
        END AS ztrata_na_prvniho,
        CASE
            WHEN v.pozice_v_cili = 1 THEN '00:00:00'::text
            ELSE COALESCE(z.casova_ztrata, s.status)
        END AS ztrata_na_dalsi_pozici,
        v.cas_nejrychlejsiho_kola
    FROM vysledky_zavodu v
    LEFT JOIN ztraty z
        ON v.id_zavodu = z.id_zavodu AND v.pozice_v_cili = z.pozice_v_cili
    LEFT JOIN statusy s
        ON v.id_statusu = s.id_statusu
    LEFT JOIN piloti p
        ON v.id_pilota = p.id_pilota
    LEFT JOIN tymy t
        ON p.id_tymu = t.id_tymu
    WHERE v.id_zavodu = id_zavodu_param AND s.id_statusu != 3
    ORDER BY v.pozice_v_cili;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM vysledek_zavodu(1);
