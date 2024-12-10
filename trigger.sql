CREATE OR REPLACE FUNCTION kontroluj_null_id_okruhu()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.id_okruhu IS NULL THEN
        RAISE EXCEPTION 'Sloupec id_okruhu nesmí být NULL';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_kontroluj_null_id_okruhu
BEFORE INSERT ON zavody
FOR EACH ROW
EXECUTE FUNCTION kontroluj_null_id_okruhu();

INSERT INTO zavody (id_zavodu, id_okruhu)
VALUES (30, NULL);

