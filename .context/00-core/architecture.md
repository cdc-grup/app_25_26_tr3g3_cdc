# Arquitectura: Circuit Copilot

## Definició de l'Estructura Tecnològica

- **Framework Mòbil:** Expo (React Native).
- **Motor de Mapes:** **Mapbox SDK** (`@rnmapbox/maps`).
  - *Motiu:* Necessari per a tesel·les vectorials personalitzades del circuit i graf d'encaminament fora de línia.
- **Motor d'AR:** **ViroCommunity (ViroReact)**.
  - *Motiu:* Suport natiu per a objectes 3D geo-ancorats (AR basada en la ubicació).
- **Backend:** Node.js (Express).
- **Base de Dades:** PostgreSQL amb l'extensió **PostGIS** activada.
- **Temps Real:** Socket.io amb analitzador **MessagePack** (per a compressió binària).

## Estratègia d'Eficiència de Dades (Entorn d'Alta Densitat)

1. **Limitació de Telemetria:**
   - El client envia actualitzacions GPS NOMÉS si: `delta_distance > 15m` O `delta_time > 45s`.
   - Evita la saturació de la xarxa durant esdeveniments de curses.
2. **Primer el mode fora de línia (Offline First):**
   - Els estils de mapa i els PDI estàtics (lavabos, portes) es descarreguen durant l'Onboarding.
   - L'ús de dades en temps d'execució es limita a: Posicions d'amics i actualitzacions de congestió.
3. **Càlcul de Rutes Local:**
   - El càlcul de la ruta es realitza al dispositiu utilitzant el graf de navegació descarregat.
   - El servidor només envia "Arrestes Bloquejades" (camins congestionats) per actualitzar els pesos del graf local.

## Estratègia de Contenidors i Entorn

- **Backend (API) & Database:** Dockeritzats mitjançant **Docker Compose**.
  - *PostgreSQL/PostGIS:* Imatge oficial.
  - *API:* Dockerfile multi-etapa (dev/prod).
- **Frontend (Mòbil):** Execució nativa (fora de Docker) per optimitzar la connexió amb el Metro Bundler i dispositius físics.