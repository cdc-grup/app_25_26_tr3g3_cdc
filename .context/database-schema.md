-- Enable Spatial extensions
CREATE EXTENSION IF NOT EXISTS postgis;

-- POIs (Static Data - Downloaded to device)
CREATE TABLE pois (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    type ENUM('toilet', 'food', 'gate', 'medical', 'parking'),
    geom GEOGRAPHY(Point, 4326), -- Use GEOGRAPHY for accurate meter calculations
    metadata JSONB -- Menus, opening hours, etc.
);

-- Telemetry (Dynamic Data - High writes, ephemeral)
-- Use a Time-Series approach or Redis for live data, flushed here for analytics
CREATE TABLE user_telemetry (
    user_id UUID,
    geom GEOGRAPHY(Point, 4326),
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- Navigation Graph (Nodes & Edges for Routing)
CREATE TABLE route_edges (
    id SERIAL PRIMARY KEY,
    source_node INT,
    target_node INT,
    geom GEOMETRY(LineString, 4326),
    base_weight INT, -- Time in seconds to cross normally
    current_congestion_weight INT DEFAULT 0 -- Dynamic update from server
);