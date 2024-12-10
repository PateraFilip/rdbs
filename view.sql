CREATE OR REPLACE VIEW Poradi_jezdcu AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY SUM(vysledky_zavodu.pocet_bodu) DESC) AS poradi,
    piloti.jmeno,
    piloti.prijmeni,
    narodnosti.nazev AS narodnost,
    tymy.nazev AS tym,
    SUM(vysledky_zavodu.pocet_bodu) AS celkovy_pocet_bodu
FROM 
    piloti
INNER JOIN 
    narodnosti ON piloti.id_narodnosti = narodnosti.id_narodnosti
LEFT JOIN 
    vysledky_zavodu ON piloti.id_pilota = vysledky_zavodu.id_pilota
INNER JOIN 
    tymy ON piloti.id_tymu = tymy.id_tymu
GROUP BY 
    piloti.id_pilota, piloti.jmeno, piloti.prijmeni, narodnosti.nazev, tymy.nazev
ORDER BY 
    celkovy_pocet_bodu DESC;