import { DrizzleD1Database } from "drizzle-orm/d1";

export type Bindings = {
	BUCKET: R2Bucket;
	AI: Ai;
	REPLICATE_API_TOKEN: string;
	BASE_URL: string;
	DB: D1Database;
	OPENAI_API_KEY: string;
};

export type Variables = {
	db: DrizzleD1Database<Record<string, never>>;
};
