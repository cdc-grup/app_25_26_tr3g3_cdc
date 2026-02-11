# Architecture: Circuit Copilot

## Tech Stack

- **Frontend:** Expo (React Native).
- **Navigation Engine:** Mapbox SDK (Support for offline tiles & custom layers).
- **Backend:** Node.js + Express.
- **Database:** PostgreSQL + PostGIS (Critical for US4, US5, US6, US7).
- **Real-time Engine:** WebSockets (Socket.io) for US10 (Friend Tracking) and US11 (Live Race Data).

## Key Systems

1. **Smart Routing Engine (US4, US7):**
   - Uses PostGIS to calculate paths between POIs and User Seat.
   - Weights segments based on telemetry data (Crowd density).
2. **AR Overlay Layer (US8, US9):**
   - Translates GPS coordinates to Camera view-space.
   - Triggers "Quick Actions" for nearest services (Toilets/Food).
3. **Data Caching (US3):**
   - Pre-loads Schedule and POI maps to allow "Pre-Race" consultation without heavy data usage.