export declare const geometry: <TName extends string>(dbName: TName, fieldConfig?: unknown) => import("drizzle-orm/pg-core").PgCustomColumnBuilder<{
    name: TName;
    dataType: "custom";
    columnType: "PgCustomColumn";
    data: string;
    driverParam: unknown;
    enumValues: undefined;
}>;
