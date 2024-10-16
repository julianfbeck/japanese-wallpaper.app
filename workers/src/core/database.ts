import { drizzle, DrizzleD1Database } from "drizzle-orm/d1";
import * as schema from "./../models/models";

export class DrizzleDB {
	private static instance?: DrizzleD1Database<typeof schema>;

	public static getInstance(d1: D1Database) {
		if (!this.instance) {
			this.instance = drizzle(d1, { logger: true, schema });
		}

		return this.instance;
	}
}
