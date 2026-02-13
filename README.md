# 📱 Circuit Copilot

Benvingut al repositori oficial. Aquesta aplicació és una solució full-stack construïda amb **Express**, **Expo** i **PostgreSQL**, organitzada en un **monorepo** amb **Turborepo** i **Docker**.

## 🗺️ Mapa de Documentació

Per garantir un procés de desenvolupament fluid i una integració perfecta amb agents d'IA, mantenim una "Font de la Veritat" en els següents directoris:

### 🧠 Context del Projecte (Llest per a IA)

- **[System Prompt](.context/00-core/system-prompt.md)**: Pautes d'estil de codi, idioma i comportament de l'agent.
- **[Arquitectura](.context/00-core/architecture.md)**: Detalls de l'estructura tècnica i flux de dades.
- **[User Journeys](.context/01-product/user-journeys.md)**: Lògica de negoci i fluxos principals d'usuari.

### 🛠️ Especificacions i Guies

- **[Guia de Configuració](docs/SETUP_GUIDE.md)**: Com configurar l'entorn local amb Docker.
- **[Guia de Desplegament](docs/DEPLOYMENT.md)**: Com portar l'aplicació a producció.
- **[Guia del Col·laborador](docs/CONTRIBUTING.md)**: Regles per a branques, commits i Pull Requests.

## ⚡ Inici Ràpid

1.  **Requisits**: Docker Desktop i Node.js instal·lats.
2.  **Instal·lar**: `npm install` a l'arrel.
3.  **Executar**: `docker-compose up` per aixecar l'API i la base de dades.
4.  **Desenvolupar**: `npm run dev` per iniciar el mode de desenvolupament amb Turbo.

## 🛠️ Estructura Tecnològica

- **Frontend:** React Native via Expo (@app/mobile).
- **Backend:** Node.js amb Express (@app/api).
- **Compartit:** Tipus i lògica comuna (@app/shared).
- **Infraestructura:** Postgres + PostGIS via Docker.
