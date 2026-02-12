# Circuit Copilot: Guia de Configuració per a Desenvolupadors

Aquesta guia descriu la configuració de l'entorn de desenvolupament local per al monorepo de **Circuit Copilot**.

## Prerequisits

Abans de clonar el repositori, assegura't de tenir instal·lat el següent:

1. **Node.js (LTS)**: v18.0.0 o superior.
2. **Docker Desktop**: En funcionament i actualitzat (necessari per a PostGIS i Redis).
3. **Git**: Per al control de versions.
4. **Entorn de Desenvolupament Mòbil**:
* **iOS**: Xcode (només per a Mac).
* **Android**: Android Studio + SDK Platform Tools.

5. **Compte de Mapbox**: Necessites un token d'accés públic.

## Estructura del Repositori (Monorepo)

Utilitzem **Turborepo** / Workspaces. No cal fer `npm install` a cada carpeta.

```text
/
├── apps/
│   ├── mobile/         # Aplicació Expo (React Native)
│   └── server/        # API Node.js + Express
├── packages/
│   ├── shared/         # Tipus TypeScript compartits (@app/shared)
│   └── database/       # Esquema de Prisma/Sequelize i Migracions
└── docker-compose.yml  # Orquestra la base de dades i Redis
```

## Pas 1: Instal·lació

1. **Clona el repositori:**
```bash
git clone https://github.com/la-teva-org/circuit-copilot.git
cd circuit-copilot
```

2. **Instal·la les dependències (Arrel):**
Això instal·la les dependències per al backend, el frontend i els paquets compartits simultàniament.
```bash
npm install
# O si utilitzes pnpm (recomanat)
pnpm install
```

## Pas 2: Variables d'Entorn

Has de crear fitxers `.env` a les carpetes específiques de l'aplicació. **No enviïs aquests fitxers al repositori.**

### Backend (`apps/backend/.env`)

```ini
PORT=3000
NODE_ENV=development
# URL interna de Docker (per a comunicació entre contenidors)
DATABASE_URL="postgresql://postgres:password@db:5432/circuit_db"
# URL de Localhost (per executar migracions des de la teva màquina local)
DIRECT_URL="postgresql://postgres:password@localhost:5432/circuit_db"
JWT_SECRET="dev-secret-key-123"
```

### Mòbil (`apps/mobile/.env`)

**⚠️ CRÍTIC:** No utilitzis `localhost` per a les URL de l'API. Els telèfons reals no poden arribar al `localhost` del teu ordinador. Utilitza la **IP de la teva xarxa local (LAN)** (ex: `192.168.1.X`).

```ini
# Obté això del tauler de control de Mapbox
EXPO_PUBLIC_MAPBOX_TOKEN="pk.eyJ1..."

# L'adreça IP del teu ordinador (comprova-la amb 'ipconfig' o 'ifconfig')
EXPO_PUBLIC_API_URL="http://192.168.1.55:3000/v1"
EXPO_PUBLIC_SOCKET_URL="http://192.168.1.55:3000"
```

## Pas 3: Base de dades i Infraestructura

Utilitzem Docker Compose per executar PostgreSQL (amb l'extensió PostGIS) i Redis.

1. **Inicia la infraestructura:**
```bash
docker-compose up -d
```

*Això aixeca la base de dades al port `5432`.*
2. **Executa les migracions:**
Inicialitza l'esquema de la base de dades.
```bash
# Executa des de l'arrel o apps/backend segons la configuració de l'script
npm run db:migrate
npm run db:seed  # (Opcional) Carrega entrades/PDI falsos
```

## Pas 4: Executar l'Aplicació Mòbil

Com que utilitzem mòduls natius (**Mapbox SDK** i **ViroReact AR**), no pots utilitzar l'aplicació estàndard "Expo Go" de l'App Store. Has de construir un **Client de Desenvolupament**.

### A. Prebuild (Només la primera vegada)

Genera les carpetes natives d'Android/iOS amb la configuració necessària.

```bash
cd apps/mobile
npx expo prebuild
```

### B. Executar en Emulador/Dispositiu

* **Android:** `npx expo run:android`
* **iOS:** `npx expo run:ios` (Requereix Mac)

> **Nota:** Aquesta ordre instal·larà l'aplicació "Development Build" al teu dispositiu. Un cop instal·lada, només caldrà que executis `npx expo start` en el futur per iniciar el Metro Bundler.

## Pas 5: Executar el Backend

Obre un nou terminal.

```bash
cd apps/backend
npm run dev
```

*Hauries de veure: `Server running on port 3000 | Connected to PostGIS`*

## Provar l'AR (Guia per a dispositius físics)

**La Realitat Augmentada (AR) no funciona en simuladors.**

1. Connecta el teu dispositiu físic Android/iOS via USB.
2. Assegura't que el teu telèfon i el teu ordinador estiguin a la **MATEIXA xarxa WiFi**.
3. Verifica que `EXPO_PUBLIC_API_URL` al teu `.env` apunti a la IP del teu ordinador, no a `localhost`.
4. Sacseja el dispositiu per obrir el menú de desenvolupador i assegura't que el "Fast Refresh" estigui activat.

## Resolució de Problemes

### "Network Request Failed" al mòbil

* **Causa:** El telèfon està intentant arribar al `localhost` o el tallafoc està bloquejant la connexió.
* **Solució:**
1. Comprova la IP del teu ordinador (`ipconfig` / `ifconfig`).
2. Actualitza el `.env` a `apps/mobile`.
3. Reinicia Expo: `npx expo start -c` (Neteja la memòria cau).
4. **Usuaris de Windows:** Permet Node.js a través del Tallafoc de Windows.

### El mapa de Mapbox està en blanc

* **Causa:** Token invàlid o error de correspondència de l'ID del paquet (Bundle ID).
* **Solució:** Assegura't que el teu Token de Mapbox tingui l'àmbit `Downloads:Read` i que el teu `bundleIdentifier` a `app.json` coincideixi amb el que has registrat a Mapbox.

### Error de PostGIS: "function st_dwithin does not exist"

* **Causa:** L'extensió PostGIS no s'ha activat.
* **Solució:** Connecta't a la base de dades i executa: `CREATE EXTENSION IF NOT EXISTS postgis;` (O comprova si les migracions s'han executat correctament).

### Diagrama de Topologia de Xarxa

Com que connectar un dispositiu mòbil físic a un backend local de Docker és el punt de fallada més comú, visulitzar el flux de xarxa és d'ajuda:
```mermaid
graph TD
    A[Dispositiu Mòbil Físic] -- "WiFi (192.168.1.x)" --> B[Router WiFi]
    B -- "Xarxa Local" --> C[El teu Ordinador]
    C -- "Port 3000" --> D[Contenidor API]
    D -- "Xarxa Docker" --> E[Contenidor PostGIS]
```