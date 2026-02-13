# Guia de Desplegament: Circuit Copilot

Aquest document descriu el procés de desplegament a producció tant per a l'API com per a l'aplicació mòbil.

## 1. Desplegament de l'API (Node.js + PostGIS)

El backend s'ha de desplegar en un proveïdor que admeti **Contenidors Docker** i **Volums Persistents** per a PostgreSQL.

### Contenidorització

Utilitzem el Dockerfile situat a `apps/backend/Dockerfile`.

* **Port:** 3000 (Express i WebSockets).
* **Entorn:** Assegura't que el proveïdor admeti sessions fixes o WebSockets (configuració de balancejador de càrrega).

### Requisits d'Infraestructura de Producció

1. **Base de dades:** PostgreSQL 15+ amb l'extensió **PostGIS** activada.
2. **SSL/TLS:** Obligatori per a la comunicació de l'aplicació mòbil (HTTPS/WSS).
3. **IP Estàtica/Domini:** Necessari per al punt final de l'API de l'aplicació mòbil.

### Variables d'Entorn (Producció)

| Variable | Descripció |
| --- | --- |
| `DATABASE_URL` | Cadena de connexió (ex: `postgres://user:pass@host:5432/db`) |
| `JWT_SECRET` | Una cadena llarga i aleatòria per signar tokens. |
| `CORS_ORIGIN` | Estableix el teu domini o `*` (es recomana restringit). |
| `NODE_ENV` | `production` |

### Flux de Desplegament (Exemple: Railway / DigitalOcean App Platform)

1. Connecta el teu repositori de GitHub.
2. Estableix el **Directori Arrel** a `/`.
3. Estableix l'**Ordre de Construcció (Build Command):** `npm install && npm run build --filter backend`.
4. Estableix l'**Ordre d'Inici (Start Command):** `npm run start --filter backend`.
5. Aplica les migracions de la base de dades: `npx prisma migrate deploy` (o equivalent).

## 2. Desplegament de l'Aplicació Mòbil (iOS i Android)

Utilitzem **EAS (Expo Application Services)** per gestionar les construccions i els enviaments.

### Prerequisits

1. **Compte de Desenvolupador d'Apple** (per a iOS).
2. **Compte de Google Play Console** (per a Android).
3. **Token de Producció de Mapbox:** Assegura't que el teu token de Mapbox estigui restringit al teu `bundleIdentifier` / `packageName` de producció.

### Perfils de Construcció (eas.json)

Assegura't que el teu `eas.json` tingui un perfil de producció:

```json
{
  "build": {
    "production": {
      "env": {
        "EXPO_PUBLIC_API_URL": "https://api.tudomini.com/v1",
        "EXPO_PUBLIC_SOCKET_URL": "https://api.tudomini.com"
      }
    }
  }
}
```

### Construcció per a les Botigues (Stores)

Executa les ordres següents des de `apps/mobile`:

**Per a Android (.aab):**

```bash
eas build --platform android --profile production
```

**Per a iOS (.ipa):**

```bash
eas build --platform ios --profile production
```

### Enviament a les Botigues

Un cop finalitzada la construcció, pots enviar-la directament des de la CLI:

```bash
eas submit --platform ios
eas submit --platform android
```

## 3. Verificació Post-Desplegament (Smoke Tests)

Després del desplegament, realitza les comprovacions següents:

1. **Connectivitat:** Obre la URL de producció en un navegador o Postman. Ha de retornar un `200 OK` o una prova d'estat (health check) en JSON.
2. **Aperitiu de mans (Handshake) de WebSocket:** Verifica que l'aplicació mòbil pugui establir una connexió `wss://`.
* *Problema comú:* Els balancejadors de càrrega com Nginx sovint necessiten una configuració explícita per permetre les capçaleres `Upgrade` per als WebSockets.

3. **Comprovació de PostGIS:** Executa una consulta de mostra de "POI més proper" a través de l'API per assegurar-te que l'extensió de la base de dades està activa.
4. **Recursos de Mapbox:** Assegura't que el mapa es carrega a la versió de producció (comprova que el Token de Producció/ID del Paquet sigui vàlid).

## Canalització (Pipeline) de CI/CD (GitHub Actions)

Recomanem una canalització que s'activi en fer un `push` a la branca `main`:

```mermaid
graph LR
    A[Push a Main] --> B{Lint i Test}
    B -- Passa --> C[Construir Imatge Docker]
    C --> D[Desplegar al Núvol]
    B -- Passa --> E[Actualització EAS - OTA]
    E --> F[Els usuaris reben actualització JS]
```

### Actualitzacions Over-the-Air (OTA)

Per a petites correccions d'errors (només JavaScript/Recursos), utilitza **Expo Updates** per saltar-te el procés de revisió de l'App Store:

```bash
eas update --branch production --message "Fix: toilet location coordinates"
```