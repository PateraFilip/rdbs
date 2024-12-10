from sqlalchemy import create_engine, Column, Integer, String, Float, func
from sqlalchemy.orm import sessionmaker, declarative_base

# Základní nastavení
Base = declarative_base()

# Definice tabulky Piloti
class Piloti(Base):
    __tablename__ = 'piloti'
    id_pilota = Column(Integer, primary_key=True)
    jmeno = Column(String)
    prijmeni = Column(String)

# Definice tabulky VysledkyZavodu
class VysledkyZavodu(Base):
    __tablename__ = 'vysledky_zavodu'
    id_vysledku = Column(Integer, primary_key=True)
    id_zavodu = Column(Integer)
    id_pilota = Column(Integer)
    pozice_na_startu = Column(Integer)
    pozice_v_cili = Column(Integer)
    id_statusu = Column(Integer)
    pocet_odjetych_kol = Column(Integer)
    pocet_bodu = Column(Integer)

# Připojení k PostgreSQL databázi (nahraďte 'username', 'password', 'localhost' a 'example_db' podle vaší konfigurace)
DATABASE_URL = "postgresql://postgres:filip@localhost/f1_database"
engine = create_engine(DATABASE_URL)

# Vytvoření Session
Session = sessionmaker(bind=engine)
session = Session()

# Spojení mezi tabulkami Piloti a VysledkyZavodu
results = session.query(
    Piloti.jmeno,
    Piloti.prijmeni,
    func.avg(VysledkyZavodu.pozice_v_cili).label('average_position')
).join(
    VysledkyZavodu, VysledkyZavodu.id_pilota == Piloti.id_pilota
).group_by(
    Piloti.id_pilota
).all()

# Výstup výsledků
for jmeno, prijmeni, avg_position in results:
    print(f"Pilot {jmeno} {prijmeni}: Průměrná pozice v cíli = {avg_position:.2f}")
