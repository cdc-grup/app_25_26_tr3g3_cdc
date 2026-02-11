# Deployment Guide: Circuit Copilot

This document outlines the production deployment process for both the Backend API and the Mobile Application.

## 1. Backend Deployment (Node.js + PostGIS)

The backend must be deployed to a provider that supports **Docker Containers** and **Persistent Volumes** for PostgreSQL.

### Containerization

We use the Dockerfile located in `apps/backend/Dockerfile`.

* **Port:** 3000 (Express & WebSockets).
* **Environment:** Ensure the provider supports sticky sessions or WebSockets (LB configuration).

### Production Infrastructure Requirements

1. **Database:** PostgreSQL 15+ with the **PostGIS** extension enabled.
2. **SSL/TLS:** Mandatory for mobile app communication (HTTPS/WSS).
3. **Static IP/Domain:** Needed for the Mobile App's API endpoint.

### Environment Variables (Production)

| Variable | Description |
| --- | --- |
| `DATABASE_URL` | Connection string (e.g., `postgres://user:pass@host:5432/db`) |
| `JWT_SECRET` | A long, random string for signing tokens. |
| `CORS_ORIGIN` | Set to your domain or `*` (restricted recommended). |
| `NODE_ENV` | `production` |

### Deployment Flow (Example: Railway / DigitalOcean App Platform)

1. Connect your GitHub Repository.
2. Set the **Root Directory** to `/`.
3. Set the **Build Command:** `npm install && npm run build --filter backend`.
4. Set the **Start Command:** `npm run start --filter backend`.
5. Apply database migrations: `npx prisma migrate deploy` (or equivalent).

## 2. Mobile App Deployment (iOS & Android)

We use **EAS (Expo Application Services)** to manage builds and submissions.

### Prerequisites

1. **Apple Developer Account** (for iOS).
2. **Google Play Console Account** (for Android).
3. **Mapbox Production Token:** Ensure your Mapbox token is restricted to your production `bundleIdentifier` / `packageName`.

### Build Profiles (eas.json)

Ensure your `eas.json` has a production profile:

```json
{
  "build": {
    "production": {
      "env": {
        "EXPO_PUBLIC_API_URL": "https://api.yourdomain.com/v1",
        "EXPO_PUBLIC_SOCKET_URL": "https://api.yourdomain.com"
      }
    }
  }
}

```

### Building for Stores

Run the following commands from `apps/mobile`:

**For Android (.aab):**

```bash
eas build --platform android --profile production

```

**For iOS (.ipa):**

```bash
eas build --platform ios --profile production

```

### Submitting to Stores

Once the build is finished, you can submit directly from the CLI:

```bash
eas submit --platform ios
eas submit --platform android

```

## 3. Post-Deployment Verification (Smoke Tests)

After deployment, perform the following checks:

1. **Connectivity:** Open the production URL in a browser/Postman. It should return a `200 OK` or a JSON health check.
2. **WebSocket Handshake:** Verify that the mobile app can establish a `wss://` connection.
* *Common Issue:* Load balancers like Nginx often need explicit config to allow `Upgrade` headers for WebSockets.


3. **PostGIS Check:** Run a sample "Nearest POI" query via the API to ensure the database extension is active.
4. **Mapbox Assets:** Ensure the map loads in the production build (checks for valid Production Token/Bundle ID).

## CI/CD Pipeline (GitHub Actions)

We recommend a pipeline that triggers on `push` to the `main` branch:

```mermaid
graph LR
    A[Push to Main] --> B{Lint & Test}
    B -- Pass --> C[Build Docker Image]
    C --> D[Deploy to Cloud]
    B -- Pass --> E[EAS Update - OTA]
    E --> F[Users receive JS update]

```

### Over-the-Air (OTA) Updates

For small bug fixes (JavaScript/Assets only), use **Expo Updates** to skip the App Store review process:

```bash
eas update --branch production --message "Fix: toilet location coordinates"

```