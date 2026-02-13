DO $$ BEGIN
 CREATE TYPE "crowd_level" AS ENUM('low', 'moderate', 'high', 'blocked');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "mobility_profile" AS ENUM('standard', 'wheelchair', 'reduced_mobility', 'visual_impairment', 'family_stroller');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "poi_type" AS ENUM('restaurant', 'wc', 'grandstand', 'gate', 'medical', 'shop', 'parking', 'meetup_point');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "surface_type" AS ENUM('asphalt', 'grass', 'gravel', 'stairs', 'ramp');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "group_members" (
	"user_id" integer,
	"group_id" integer,
	"joined_at" timestamp,
	"last_location" geometry(Point, 4326),
	"last_updated" timestamp,
	CONSTRAINT "group_members_user_id_group_id_pk" PRIMARY KEY("user_id","group_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "groups" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar,
	"invite_code" varchar,
	"created_by" integer,
	"meeting_point" geometry(Point, 4326),
	"created_at" timestamp,
	CONSTRAINT "groups_invite_code_unique" UNIQUE("invite_code")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "offline_packages" (
	"id" integer PRIMARY KEY NOT NULL,
	"region_name" varchar,
	"file_url" varchar,
	"version" varchar,
	"size_mb" double precision
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "path_segments" (
	"id" integer PRIMARY KEY NOT NULL,
	"start_node" geometry(Point, 4326),
	"end_node" geometry(Point, 4326),
	"surface" "surface_type",
	"slope_percentage" double precision,
	"has_stairs" boolean,
	"current_crowd_level" "crowd_level" DEFAULT 'low'
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "points_of_interest" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"description" text,
	"type" "poi_type" NOT NULL,
	"location" geometry(Point, 4326) NOT NULL,
	"current_crowd_level" "crowd_level" DEFAULT 'low',
	"is_wheelchair_accessible" boolean DEFAULT true,
	"has_priority_lane" boolean
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "saved_locations" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer,
	"label" varchar,
	"location" geometry(Point, 4326),
	"created_at" timestamp
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "tickets" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"code" varchar,
	"gate" varchar,
	"zone_name" varchar,
	"seat_row" varchar,
	"seat_number" varchar,
	"seat_location" geometry(Point, 4326),
	"is_active" boolean DEFAULT true,
	"created_at" timestamp,
	CONSTRAINT "tickets_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"email" varchar NOT NULL,
	"password_hash" varchar NOT NULL,
	"full_name" varchar,
	"mobility_mode" "mobility_profile" DEFAULT 'standard',
	"avoid_stairs" boolean DEFAULT false,
	"avoid_crowds" boolean DEFAULT false,
	"avoid_slopes" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now(),
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "group_members" ADD CONSTRAINT "group_members_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "group_members" ADD CONSTRAINT "group_members_group_id_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "groups"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "groups" ADD CONSTRAINT "groups_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "saved_locations" ADD CONSTRAINT "saved_locations_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tickets" ADD CONSTRAINT "tickets_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
