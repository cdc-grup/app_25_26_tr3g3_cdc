# Architecture: Circuit Copilot

## Tech Stack Definition

- **Mobile Framework:** Expo (React Native).
- **Maps Engine:** **Mapbox SDK** (`@rnmapbox/maps`).
  - *Reason:* Required for custom vector tiles of the circuit and offline routing graph.
- **AR Engine:** **ViroCommunity (ViroReact)**.
  - *Reason:* Native support for Geo-anchored 3D objects (Location-based AR).
- **Backend:** Node.js (Express).
- **Database:** PostgreSQL with **PostGIS** extension enabled.
- **Real-time:** Socket.io with **MessagePack** parser (for binary compression).

## Data Efficiency Strategy (High Density Environment)

1. **Telemetry Throttling:**
   - Client sends GPS updates ONLY if: `delta_distance > 15m` OR `delta_time > 45s`.
   - Prevents network saturation during race events.
2. **Offline First:**
   - Map styles and static POIs (toilets, gates) are downloaded during Onboarding.
   - Runtime data usage is limited to: Friend positions and Congestion updates.
3. **Local Pathfinding:**
   - Route calculation happens on the device using the downloaded navigation graph.
   - Server only pushes "Blocked Edges" (congested paths) to update the local graph weights.