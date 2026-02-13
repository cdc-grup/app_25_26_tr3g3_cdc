"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
require("dotenv/config");
const migrator_1 = require("drizzle-orm/node-postgres/migrator");
const index_1 = require("./index");
async function main() {
    console.log('Running migrations...');
    await (0, migrator_1.migrate)(index_1.db, { migrationsFolder: './drizzle' });
    console.log('Migrations completed successfully.');
    await index_1.pool.end();
    process.exit(0);
}
main().catch((err) => {
    console.error('Migration failed:', err);
    process.exit(1);
});
