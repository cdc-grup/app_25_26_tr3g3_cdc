-- Activa les extensions espacials
CREATE EXTENSION IF NOT EXISTS postgis;

-- PDI (Dades estàtiques - Descarregades al dispositiu)
CREATE TABLE pois (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    type ENUM('toilet', 'food', 'gate', 'medical', 'parking'),
    geom GEOGRAPHY(Point, 4326), -- Utilitza GEOGRAPHY per a càlculs de metres precisos
    metadata JSONB -- Menús, horaris d'obertura, etc.
);

-- Telemetria (Dades dinàmiques - Moltes escriptures, efímeres)
-- Utilitza un enfocament de sèries temporals (Time-Series) o Redis per a dades en viu, bolcat aquí per a analítica
CREATE TABLE user_telemetry (
    user_id UUID,
    geom GEOGRAPHY(Point, 4326),
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- Graf de Navegació (Nodes i Arrestes per a l'Encaminament)
CREATE TABLE route_edges (
    id SERIAL PRIMARY KEY,
    source_node INT,
    target_node INT,
    geom GEOMETRY(LineString, 4326),
    base_weight INT, -- Temps en segons per creuar normalment
    current_congestion_weight INT DEFAULT 0 -- Actualització dinàmica des del servidor
);