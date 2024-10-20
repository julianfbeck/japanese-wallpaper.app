import { desc, eq, sql } from "drizzle-orm";
import { Hono } from "hono";
import { Bindings, Variables } from "../core/workers";
import { ReplicateLogFlux, upscaleWallpaper } from "../lib/replicate";
import { categoryCounters, wallpapers } from "../models/models";
import {
	getCategoryValue,
	JapaneseDarkModeWallpaperCategories,
} from "../wallpaper-types";

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>();

//gets top images for today
app.get("/today", async (c) => {
	// get category from query
	const category = c.req.query("category");
	let body = (await c.req.json()) as ReplicateLogFlux;
	if (body.status !== "succeeded") {
		return c.text("Not completed");
	}
	if (!category) {
		return c.text("No category");
	}

	await upscaleWallpaper(c.env, body.output, category);
	console.log("Upscale buffer");

	c.status(200);
	return c.body("Done");
});

app.get("/latest", async (c) => {
	const wallpapers = await await c.var.db.query.wallpapers.findMany({
		orderBy: (wallpapers, { desc }) => [desc(wallpapers.created_at)],
		limit: 3,
	});

	return c.json(wallpapers);
});

const isDarkModeCategory = (category: string) => {
	return JapaneseDarkModeWallpaperCategories.has(category);
};

//gets image categories
app.get("/categories/light", async (c) => {
	const categories = await c.var.db.select().from(categoryCounters);
	const extendedCategories = categories
		.filter((category) => !isDarkModeCategory(category.category))
		.map((category) => {
			return {
				category: category.category,
				count: category.count,
				value: getCategoryValue(category.category),
			};
		});
	return c.json(extendedCategories);
});

app.get("/categories/dark", async (c) => {
	const categories = await c.var.db.select().from(categoryCounters);
	const extendedCategories = categories
		.filter((category) => isDarkModeCategory(category.category))
		.map((category) => {
			return {
				category: category.category,
				count: category.count,
				value: getCategoryValue(category.category),
			};
		});
	return c.json(extendedCategories);
});

app.post("/download", async (c) => {
	const { name } = await c.req.json();

	if (!name) {
		c.status(400);
		return c.json({ error: "Wallpaper name is required" });
	}

	try {
		const result = await c.var.db
			.update(wallpapers)
			.set({ downloads: sql`${wallpapers.downloads} + 1` })
			.where(eq(wallpapers.filename, name))
			.returning({ updatedDownloads: wallpapers.downloads });

		if (result.length === 0) {
			c.status(404);
			return c.json({ error: "Wallpaper not found" });
		}

		return c.json({
			message: "Download count incremented successfully",
			newDownloadCount: result[0].updatedDownloads,
		});
	} catch (error) {
		console.error("Error updating download count:", error);
		c.status(500);
		return c.json({ error: "Internal server error" });
	}
});

app.get("/top-downloads", async (c) => {
	try {
		const topWallpapers = await c.var.db
			.select({
				id: wallpapers.id,
				filename: wallpapers.filename,
				category: wallpapers.category,
				downloads: wallpapers.downloads,
				created_at: wallpapers.created_at,
			})
			.from(wallpapers)
			.orderBy(desc(wallpapers.downloads))
			.limit(10);

		return c.json(topWallpapers);
	} catch (error) {
		console.error("Error fetching top downloads:", error);
		c.status(500);
		return c.json({ error: "Internal server error" });
	}
});

export default app;
