# Contributing to Circuit Copilot

First off, thank you for helping us build the ultimate race-day companion! To maintain a high-quality codebase and a smooth workflow in our monorepo, please follow these guidelines.

## Branching Strategy

We use a **Feature Branch** workflow. Always branch off `main` and merge back via Pull Request.

* **Feature:** `feat/feature-name` (e.g., `feat/ar-arrows`)
* **Bug Fix:** `fix/bug-name` (e.g., `fix/socket-reconnection`)
* **Documentation:** `docs/description`
* **Refactor:** `refactor/component-name`

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/). This allows us to auto-generate changelogs and manage versions easily.

**Format:** `<type>(scope): <description>`

* `feat(mobile): add mapbox user tracking`
* `fix(api): correct postgis query for nearest toilets`
* `docs(shared): update user ticket interface`
* `chore(root): update dependencies`

## Monorepo Workflow (Turborepo)

Since we are in a monorepo, pay attention to where you are adding code:

1. **Shared Logic:** If a type, interface, or utility is used by both the App and the API, put it in `packages/shared`.
2. **Scripts:** Use the root `package.json` to run tasks across the whole repo:
* `npm run dev`: Starts all apps (Backend + Mobile) in parallel.
* `npm run build`: Builds all packages.
* `npm run lint`: Runs ESLint across all apps.

## Coding Standards

### TypeScript

* **No `any`:** Use proper typing. If you are unsure, define an interface in `packages/shared`.
* **Explicit Returns:** Always define the return type of your functions and API endpoints.

### Linting & Formatting

We use **ESLint** and **Prettier**. Most IDEs will format on save, but you can run it manually:

```bash
npm run lint:fix

```

### Git Hooks (Husky)

Before every commit, a pre-commit hook runs to ensure your code:

1. Has no linting errors.
2. Passes basic tests.
**Do not bypass these hooks.**

## Pull Request (PR) Process

1. **Update Documentation:** If you add a new API endpoint, update `api-contract.md`. If you change the state logic, update `app-states.md`.
2. **Self-Review:** Look at your own code for console logs or "TODOs" before opening the PR.
3. **The "AR" Rule:** If your PR changes AR logic, you **must** include a short video or GIF of the feature working on a physical device in the PR description.
4. **Reviewers:** At least one other developer must approve the PR before merging to `main`.

## Shared Directory Rules

When modifying `packages/shared`:

1. Run `npm run build` in the shared folder to ensure the TypeScript declaration files are updated.
2. Restart the Metro Bundler (Mobile) and the Node Server (Backend) to pick up the changes.

## Troubleshooting for Contributors

* **"Type not found in Mobile":** If you added a type in `shared` but the Mobile app doesn't see it, try `npm install` at the root and restart the Expo server.
* **"Docker Port Conflict":** If you can't start the DB, check if you have another PostgreSQL instance running on port `5432`.

### **Final Project Status**

You now have a professional-grade documentation suite:

* **`.context/`**: The "Source of Truth" for your AI assistant.
* **`docs/`**: The "Standard Operating Procedures" for your human team.