# API Contract v1.0 - Circuit Copilot

## 1. General Standards

* **Base URL:** `https://api.circuit-copilot.com/v1`
* **Authentication:** Bearer Token (JWT) in Headers. `Authorization: Bearer <token>`
* **Data Format:** JSON for REST, MessagePack (binary) for WebSockets (Location updates).
* **Geo Format:** All coordinates must follow **GeoJSON** standard: `[longitude, latitude]`.

## 2. REST Endpoints (HTTP)

### 🟢 Auth & Onboarding (US1, US2)

#### `POST /auth/ticket-sync`

Vincula un tiquet físico/digital al usuario y extrae su metadatos de acceso.

* **Body:**

```json
{
  "qr_code_data": "CRYPTIC_STRING_FROM_SCANNER",
  "device_id": "uuid-v4"
}

```

* **Response (200 OK):**

```json
{
  "user_id": "u-123",
  "token": "jwt_token_here",
  "ticket_info": {
    "gate": "Gate 3",
    "zone": "Tribuna G",
    "seat": "Row 12, Seat 4",
    "seat_coordinates": [2.2645, 41.5701] // Target for navigation
  }
}

```



#### `PATCH /users/me/parking` (US34)

Guarda la ubicación del coche para la salida.

* **Body:**

```json
{
  "location": [2.2610, 41.5690],
  "notes": "Parking B, Row 4"
}

```



### 🔵 Navigation & Map Data (US6, US9)

#### `GET /pois`

Obtiene los Puntos de Interés estáticos. Cacheable en el dispositivo (Local SQLite).

* **Query Params:** `?category=toilet,food&changed_since=2023-10-01`
* **Response (200 OK):**

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": { "type": "Point", "coordinates": [2.26, 41.57] },
      "properties": {
        "id": 101,
        "name": "Burger Truck #4",
        "category": "food",
        "wait_time_minutes": 15 // Calculated from crowd density
      }
    }
  ]
}

```



### 🟣 Smart Routing (use US4, US7)

#### `POST /navigation/route`

Solicita una ruta peatonal considerando la congestión actual.

* **Body:**

```json
{
  "origin": [2.261, 41.568],
  "destination": [2.265, 41.572],
  "mode": "walking" // Future: 'vip_shuttle'
}

```

* **Response (200 OK):**

```json
{
  "route_geometry": "encoded_polyline_string", // Lightweight for Mapbox
  "distance_meters": 450,
  "estimated_time_seconds": 380,
  "congestion_level": "high", // UI triggers warning color
  "ar_checkpoints": [ // Nodes where AR arrows should appear
    { "coords": [2.262, 41.569], "instruction": "Turn left at Red Bull stand" }
  ]
}

```

## 3. WebSocket Events (Real-time)

**Protocol:** Socket.io
**Namespace:** `/live-track`

### 📤 Client Emits (Lo que envía el móvil)

#### `user:update_location` (Throttled)

Se envía máx. 1 vez cada 30s o si se mueve >20m.

* **Payload:**

```json
{
  "lat": 41.5701,
  "lng": 2.2645,
  "accuracy": 12.5, // Meters. Ignore if > 50m
  "heading": 180, // For AR orientation
  "speed": 1.2 // m/s
}

```



#### `group:join`

Para unirse a un grupo de amigos.

* **Payload:** `{ "group_code": "FAST-CARS-24" }`

### 📥 Server Emits (Lo que recibe el móvil)

#### `group:locations`

Posiciones de los amigos en el mapa.

* **Payload:**

```json
[
  { "user_id": "u-456", "name": "Marc", "coords": [2.26, 41.57], "last_seen": "10s ago" },
  { "user_id": "u-789", "name": "Laia", "coords": [2.27, 41.58], "last_seen": "2m ago" } // UI shows 'offline' icon
]

```

#### `race:status` (US11)

Datos de carrera en vivo (Low Latency).

* **Payload:**

```json
{
  "lap": 45,
  "total_laps": 66,
  "flag": "yellow", // Triggers UI Alert
  "leaderboard_top3": ["VER", "HAM", "NOR"]
}

```

## 4. Error Handling Standards

Todas las respuestas de error deben seguir este formato para que el Frontend muestre mensajes consistentes:

```json
{
  "error": {
    "code": "TICKET_INVALID",
    "message": "The QR code implies a generic entry, please select zone manually.",
    "user_friendly_message": "No hem pogut detectar la teva zona. Si us plau, selecciona-la manualment.",
    "status": 400
  }
}

```
