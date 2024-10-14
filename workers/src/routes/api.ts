import { Hono } from "hono";
import { Bindings, Variables } from "../core/workers";
import { downloadAndStoreImage } from "../lib/bucket";
import { ReplicateLogFlux, upscaleWallpaper } from "../lib/replicate";
import { categoryCounters, wallpapers } from "../models/models";
import { getCategoryValue } from "../wallpaper-types";

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

//gets image categories
app.get("/categories", async (c) => {
	const categories = await c.var.db.select().from(categoryCounters);

	const extendedCategories = categories.map((category) => {
		return {
			category: category.category,
			count: category.count,
			value: getCategoryValue(category.category),
		};
	});
	return c.json(extendedCategories);
});

export default app;
