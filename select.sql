--počet vítězství (group + count)
SELECT 
    piloti.jmeno, 
    piloti.prijmeni, 
    narodnosti.nazev AS narodnost, 
    tymy.nazev AS tym, 
    COUNT(vysledky_zavodu.pozice_v_cili) AS pocet_vitezstvi
FROM 
    vysledky_zavodu
INNER JOIN 
    piloti ON vysledky_zavodu.id_pilota = piloti.id_pilota
INNER JOIN 
    narodnosti ON piloti.id_narodnosti = narodnosti.id_narodnosti
INNER JOIN 
    tymy ON piloti.id_tymu = tymy.id_tymu
WHERE 
    vysledky_zavodu.pozice_v_cili = 1
GROUP BY 
    piloti.id_pilota, piloti.jmeno, piloti.prijmeni, narodnosti.nazev, tymy.nazev
ORDER BY 
    pocet_vitezstvi DESC;

--průměrný počet záznamů
SELECT
    ((SELECT COUNT(*) FROM Vysledky_zavodu) +
    (SELECT COUNT(*) FROM Zavody) +
    (SELECT COUNT(*) FROM Okruhy) +
    (SELECT COUNT(*) FROM Staty) +
    (SELECT COUNT(*) FROM Dodavatele_motoru) +
    (SELECT COUNT(*) FROM Tymy) +
    (SELECT COUNT(*) FROM Reditele_tymu) +
    (SELECT COUNT(*) FROM Piloti) +
    (SELECT COUNT(*) FROM Statusy) +
    (SELECT COUNT(*) FROM Narodnosti)) /10 AS prumerny_pocet_zaznamu_na_tabulku;

--počet odjetých závodů (vnořený select)
SELECT 
    piloti.jmeno, 
    piloti.prijmeni, 
    narodnosti.nazev AS narodnost, 
    tymy.nazev AS tym, 
    COALESCE(pocet_startu.pocet, 0) AS pocet_startu
FROM 
    piloti
INNER JOIN 
    narodnosti ON piloti.id_narodnosti = narodnosti.id_narodnosti
INNER JOIN 
    tymy ON piloti.id_tymu = tymy.id_tymu
LEFT JOIN 
    (
        SELECT 
            id_pilota, 
            COUNT(pozice_na_startu) AS pocet
        FROM 
            vysledky_zavodu
        WHERE 
            pozice_na_startu IS NOT NULL
        GROUP BY 
            id_pilota
    ) AS pocet_startu ON piloti.id_pilota = pocet_startu.id_pilota
ORDER BY 
    pocet_startu DESC, piloti.prijmeni, piloti.jmeno;

