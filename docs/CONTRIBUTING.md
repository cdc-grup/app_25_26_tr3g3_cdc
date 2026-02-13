# Contribuir a Circuit Copilot

En primer lloc, gràcies per ajudar-nos a construir el millor acompanyant per als dies de cursa! Per mantenir una base de codi d'alta qualitat i un flux de treball fluid en el nostre monorepo, segueix aquestes pautes.

## Estratègia de Brancament (Branching)

Utilitzem un flux de treball de **Branca de Funcionalitat (Feature Branch)**. Crea sempre la branca a partir de `main` i fusiona-la mitjançant una Pull Request.

* **Funcionalitat:** `feat/feature-name` (ex: `feat/ar-arrows`)
* **Correcció d'errors (Bug Fix):** `fix/bug-name` (ex: `fix/socket-reconnection`)
* **Documentació:** `docs/description`
* **Refactorització:** `refactor/component-name`

## Convenció de Missatges de Commit

Seguim els [Commits Convencionals](https://www.conventionalcommits.org/). Això ens permet autogenerar registres de canvis (changelogs) i gestionar versions fàcilment.

**Format:** `<tipus>(àmbit): <descripció>`

* `feat(mobile): add mapbox user tracking`
* `fix(api): correct postgis query for nearest toilets`
* `docs(shared): update user ticket interface`
* `chore(root): update dependencies`

## Flux de Treball al Monorepo (Turborepo)

Com que estem en un monorepo, para atenció a on afegeixes el codi:

1. **Lògica Compartida:** Si un tipus, interfície o utilitat s'utilitza tant a l'App com a l'API, posa-ho a `packages/shared`.
2. **Scripts:** Utilitza el `package.json` arrel per executar tasques a tot el repositori:
* `npm run dev`: Inicia totes les aplicacions (Backend + Mòbil) en paral·lel.
* `npm run build`: Construeix tots els paquets.
* `npm run lint`: Executa ESLint a totes les aplicacions.

## Estàndards de Programació

### TypeScript

* **No `any`:** Utilitza el tipat correcte. Si no n'estàs segur, defineix una interfície a `packages/shared`.
* **Retorns Explícits:** Defineix sempre el tipus de retorn de les teves funcions i punts finals de l'API.

### Llinting i Format

Utilitzem **ESLint** i **Prettier**. La majoria dels IDE li donaran format en desar, però pots executar-ho manualment:

```bash
npm run lint:fix
```

### Git Hooks (Husky)

Abans de cada commit, s'executa un hook de pre-commit per assegurar que el teu codi:

1. No té errors de linting.
2. Passa les proves bàsiques.
**No et saltis aquests hooks.**

## Procés de Pull Request (PR)

1. **Actualitza la Documentació:** Si afegeixes un nou punt final a l'API, actualitza `api-contract.md`. Si canvies la lògica d'estats, actualitza `app-states.md`.
2. **Auto-revisió:** Revisa el teu propi codi per si hi ha console logs o "TODOs" abans d'obrir la PR.
3. **La Regla de l'"AR":** Si la teva PR canvia lògica d'AR, **has d'incloure** un vídeo curt o un GIF de la funcionalitat funcionant en un dispositiu físic a la descripció de la PR.
4. **Revisors:** Almenys un altre desenvolupador ha d'aprovar la PR abans de fusionar-la a `main`.

## Regles del Directori Compartit (Shared)

Quan modifiquis `packages/shared`:

1. Executa `npm run build` a la carpeta shared per assegurar-te que els fitxers de declaració de TypeScript s'actualitzen.
2. Reinicia el Metro Bundler (Mòbil) i el Servidor API (Backend) per recollir els canvis.

## Resolució de Problemes per a Col·laboradors

* **"Tipus no trobat al Mòbil":** Si has afegit un tipus a `shared` però l'app mòbil no el veu, prova `npm install` a l'arrel i reinicia el servidor Expo.
* **"Conflicte de ports a Docker":** Si no pots iniciar la base de dades, comprova si tens una altra instància de PostgreSQL executant-se al port `5432`.

### **Estat Final del Projecte**

Ara tens un conjunt de documentació de nivell professional:

* **`.context/`**: La "Font de la Veritat" per al teu assistent d'IA.
* **`docs/`**: Els "Procediments Operatius Estàndard" per al teu equip humà.