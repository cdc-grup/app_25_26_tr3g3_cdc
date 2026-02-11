# Circuit Copilot: Developer Setup Guide

This guide covers the local development environment setup for the **Circuit Copilot** Monorepo.

## Prerequisites

Before cloning the repository, ensure you have the following installed:

1. **Node.js (LTS)**: v18.0.0 or higher.
2. **Docker Desktop**: Running and updated (required for PostGIS & Redis).
3. **Git**: For version control.
4. **Mobile Development Environment**:
* **iOS**: Xcode (Mac only).
* **Android**: Android Studio + SDK Platform Tools.


5. **Mapbox Account**: You need a public access token.

## Repository Structure (Monorepo)

We use **Turborepo** / Workspaces. You don't need to `npm install` in every folder.

```text
/
├── apps/
│   ├── mobile/         # Expo (React Native) App
│   └── server/        # Node.js + Express API
├── packages/
│   ├── shared/         # Shared TypeScript Types (Frontend <-> Backend contract)
│   └── database/       # Prisma/Sequelize Schema & Migrations
└── docker-compose.yml  # Orchestrates DB and Redis

```

## Step 1: Installation

1. **Clone the repo:**
```bash
git clone https://github.com/your-org/circuit-copilot.git
cd circuit-copilot

```

2. **Install dependencies (Root):**
This installs dependencies for the backend, frontend, and shared packages simultaneously.
```bash
npm install
# OR if using pnpm (recommended)
pnpm install

```

## Step 2: Environment Variables

You must create `.env` files in the specific application folders. **Do not commit these files.**

### Backend (`apps/backend/.env`)

```ini
PORT=3000
NODE_ENV=development
# Docker internal URL (for container-to-container)
DATABASE_URL="postgresql://postgres:password@db:5432/circuit_db"
# Localhost URL (for running migrations from your host machine)
DIRECT_URL="postgresql://postgres:password@localhost:5432/circuit_db"
JWT_SECRET="dev-secret-key-123"

```

### Mobile (`apps/mobile/.env`)

**⚠️ CRITICAL:** Do not use `localhost` for API URLs. Real phones cannot reach your computer's `localhost`. Use your computer's **Local LAN IP** (e.g., `192.168.1.X`).

```ini
# Get this from Mapbox Dashboard
EXPO_PUBLIC_MAPBOX_TOKEN="pk.eyJ1..."

# Your Computer's IP Address (Check using 'ipconfig' or 'ifconfig')
EXPO_PUBLIC_API_URL="http://192.168.1.55:3000/v1"
EXPO_PUBLIC_SOCKET_URL="http://192.168.1.55:3000"

```

## Step 3: Database & Infrastructure

We use Docker Compose to run PostgreSQL (with PostGIS extension) and Redis.

1. **Start the infrastructure:**
```bash
docker-compose up -d

```

*This spins up the database on port `5432`.*
2. **Run Migrations:**
Initialize the database schema.
```bash
# Run from root or apps/backend depending on script setup
npm run db:migrate
npm run db:seed  # (Optional) Loads fake tickets/POIs

```

## Step 4: Running the Mobile App

Because we use Native Modules (**Mapbox SDK** & **ViroReact AR**), you cannot use the standard "Expo Go" app from the App Store. You must build a **Development Client**.

### A. Prebuild (First time only)

Generates the native Android/iOS folders with the required config.

```bash
cd apps/mobile
npx expo prebuild

```

### B. Run on Emulator/Device

* **Android:** `npx expo run:android`
* **iOS:** `npx expo run:ios` (Requires Mac)

> **Note:** This command will install the "Development Build" app on your device. Once installed, you can just run `npx expo start` in the future to start the Metro Bundler.

## Step 5: Running the Backend

Open a new terminal.

```bash
cd apps/backend
npm run dev

```

*You should see: `Server running on port 3000 | Connected to PostGIS*`

## Testing AR (Physical Device Guide)

**Augmented Reality (AR) does not work on Simulators.**

1. Connect your physical Android/iOS device via USB.
2. Ensure your phone and computer are on the **SAME WiFi network**.
3. Verify that `EXPO_PUBLIC_API_URL` in your `.env` points to your computer's IP, not `localhost`.
4. Shake the device to open the Developer Menu and ensure "Fast Refresh" is enabled.

## Troubleshooting

### "Network Request Failed" on Mobile

* **Cause:** The phone is trying to reach `localhost` or the firewall is blocking the connection.
* **Fix:**
1. Check your computer's IP (`ipconfig` / `ifconfig`).
2. Update `.env` in `apps/mobile`.
3. Restart Expo: `npx expo start -c` (Clear cache).
4. **Windows Users:** Allow Node.js through Windows Firewall.



### Mapbox Map is Blank

* **Cause:** Invalid Token or Bundle ID mismatch.
* **Fix:** Ensure your Mapbox Token has the `Downloads:Read` scope and that your `bundleIdentifier` in `app.json` matches what you registered in Mapbox.

### PostGIS Error: "function st_dwithin does not exist"

* **Cause:** The PostGIS extension wasn't enabled.
* **Fix:** Connect to the DB and run: `CREATE EXTENSION IF NOT EXISTS postgis;` (Or check if migrations ran correctly).
### Network Topology Diagram

Since connecting a physical mobile device to a local Docker backend is the most common point of failure, visualizing the network flow is helpful: