from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean, ForeignKey, Float, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from models import Base
import enum


class UserRole(enum.Enum):
    ADMIN = "Administrateur"
    EXPERT = "Expert-comptable"
    COMMISSAIRE = "Commissaire aux comptes"
    COLLABORATEUR = "Collaborateur"
    FISCALISTE = "Fiscaliste"
    JURISTE = "Juriste"
    CLIENT = "Client"


class DocumentStatus(enum.Enum):
    TO_ANALYZE = "À analyser"
    IN_PROGRESS = "En cours"
    VALIDATED = "Validé"
    SIGNED = "Signé"
    ARCHIVED = "Archivé"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False, index=True)
    email = Column(String(100), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(50), nullable=False, default=UserRole.COLLABORATEUR.value)
    full_name = Column(String(100))
    phone = Column(String(20))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    documents = relationship("Document", back_populates="creator")
    audit_logs = relationship("AuditLog", back_populates="user")


class Client(Base):
    __tablename__ = "clients"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False, index=True)
    code = Column(String(50), unique=True, index=True)
    ice = Column(String(50), index=True)  # Identifiant Commun de l'Entreprise
    rc = Column(String(50), index=True)  # Registre de Commerce
    address = Column(Text)
    city = Column(String(100))
    phone = Column(String(20))
    email = Column(String(100))
    contact_person = Column(String(100))
    contact_phone = Column(String(20))
    contact_email = Column(String(100))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    documents = relationship("Document", back_populates="client")
    declarations = relationship("Declaration", back_populates="client")
    exercices = relationship("Exercice", back_populates="client")


class Exercice(Base):
    __tablename__ = "exercices"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)
    year = Column(Integer, nullable=False)
    start_date = Column(DateTime(timezone=True))
    end_date = Column(DateTime(timezone=True))
    status = Column(String(20), default="Ouvert")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    client = relationship("Client", back_populates="exercices")
    documents = relationship("Document", back_populates="exercice")


class Document(Base):
    __tablename__ = "documents"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False, index=True)
    exercice_id = Column(Integer, ForeignKey("exercices.id"))
    type = Column(String(50), nullable=False, index=True)
    title = Column(String(200), nullable=False)
    description = Column(Text)
    file_path = Column(String(500))
    status = Column(String(20), default=DocumentStatus.TO_ANALYZE.value, index=True)
    created_by = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    archived_at = Column(DateTime(timezone=True))

    client = relationship("Client", back_populates="documents")
    exercice = relationship("Exercice", back_populates="documents")
    creator = relationship("User", back_populates="documents")


class DeclarationType(enum.Enum):
    TVA = "TVA"
    IBS = "IBS"
    TAP = "TAP"
    G50 = "G50"
    IS = "IS"
    CNSS = "CNSS"


class Declaration(Base):
    __tablename__ = "declarations"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False, index=True)
    exercice_id = Column(Integer, ForeignKey("exercices.id"))
    type = Column(String(20), nullable=False, index=True)
    period = Column(String(20))  # e.g., "2024-01" for January 2024
    amount = Column(Float, default=0)
    status = Column(String(20), default="Brouillon")
    submitted_at = Column(DateTime(timezone=True))
    deadline = Column(DateTime(timezone=True))
    notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    client = relationship("Client", back_populates="declarations")


class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), index=True)
    action = Column(String(50), nullable=False, index=True)
    table_name = Column(String(50))
    record_id = Column(Integer)
    details = Column(Text)
    ip_address = Column(String(50))
    created_at = Column(DateTime(timezone=True), server_default=func.now(), index=True)

    user = relationship("User", back_populates="audit_logs")


class RegulationText(Base):
    __tablename__ = "regulation_texts"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(500), nullable=False)
    source = Column(String(100))  # JORADP, etc.
    reference = Column(String(100))
    publication_date = Column(DateTime(timezone=True))
    effective_date = Column(DateTime(timezone=True))
    content = Column(Text)
    category = Column(String(50), index=True)
    tags = Column(String(200))
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Mission(Base):
    __tablename__ = "missions"

    id = Column(Integer, primary_key=True, index=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False, index=True)
    type = Column(String(50), nullable=False)  # Audit, Review, etc.
    year = Column(Integer)
    status = Column(String(20), default="Planifiée")
    start_date = Column(DateTime(timezone=True))
    end_date = Column(DateTime(timezone=True))
    notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    client = relationship("Client")
    anomalies = relationship("Anomaly", back_populates="mission")


class Anomaly(Base):
    __tablename__ = "anomalies"

    id = Column(Integer, primary_key=True, index=True)
    mission_id = Column(Integer, ForeignKey("missions.id"), nullable=False)
    description = Column(Text, nullable=False)
    severity = Column(String(20))  # Mineur, Majeur, Critique
    status = Column(String(20), default="Ouvert")
    resolution = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    resolved_at = Column(DateTime(timezone=True))

    mission = relationship("Mission", back_populates="anomalies")