import { index, int, sqliteTable, text } from "drizzle-orm/sqlite-core";
import { v4 as uuid } from "uuid";

export const wallpapers = sqliteTable(
	"wallpapers",
	{
		id: text("id")
			.notNull()
			.primaryKey()
			.$default(() => uuid()),
		filename: text("name").notNull(),
		category: text("category").notNull(),
		is_free: int("is_free").notNull().default(0),
		downloads: int("downloads").notNull().default(0),
		created_at: int("created_at", { mode: "timestamp" }).$default(
			() => new Date()
		),
	},
	(table) => {
		return {
			categoryIdx: index("category_idx").on(table.category),
			created_atIdx: index("created_at_idx").on(table.created_at),
		};
	}
);

export const categoryCounters = sqliteTable("category_counters", {
	category: text("category").primaryKey(),
	count: int("count").notNull().default(0),
	sorting: int("sorting").default(0),
});
