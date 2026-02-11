-- US1 & US2: Profile & Tickets

CREATE TABLE users (
    id UUID PRIMARY KEY,
    ticket_id VARCHAR(255) NULL,
    zone VARCHAR(50), -- US1
    gate VARCHAR(10),
    seat VARCHAR(20),
    is_pre_race_user BOOLEAN DEFAULT true -- US2
);

-- US3 & US11: Events & Race Data
CREATE TABLE events_schedule (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    start_time TIMESTAMP,
    description TEXT
);

-- US6 & US9: POIs (Points of Interest)
CREATE TABLE pois (
    id SERIAL PRIMARY KEY,
    name_ca VARCHAR(100),
    category ENUM('toilet', 'food', 'merch', 'medical', 'gate'),
    location GEOGRAPHY(POINT, 4326)
);

-- US10: Social Tracking
CREATE TABLE friend_groups (
    group_id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    shared_at TIMESTAMP DEFAULT NOW()
);