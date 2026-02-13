"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.geometry = void 0;
const pg_core_1 = require("drizzle-orm/pg-core");
exports.geometry = (0, pg_core_1.customType)({
    dataType() {
        return 'geometry(Point, 4326)';
    },
});
