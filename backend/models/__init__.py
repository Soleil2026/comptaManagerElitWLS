from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from config import config

engine = None
SessionLocal = None
Base = declarative_base()


def init_db(app):
    global engine, SessionLocal
    db_config = config[app.config.get('ENV', 'default')]
    engine = create_engine(db_config.SQLALCHEMY_DATABASE_URI, pool_pre_ping=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()