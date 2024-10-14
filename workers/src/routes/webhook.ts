import { eq } from "drizzle-orm";
import { Hono } from "hono";
import { DrizzleDB } from "../core/database";
import { Bindings, Variables } from "../core/workers";
import { downloadAndStoreImage } from "../lib/bucket";
import { ReplicateLogFlux, upscaleWallpaper } from "../lib/replicate";
import { categoryCounters, wallpapers } from "../models/models";

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>();

app.post("/generated", async (c) => {
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

app.post("/upscale", async (c) => {
	const category = c.req.query("category");
	const body = (await c.req.json()) as { output: string[] };
	let updatedCount: number = 0;
	let bucketFilename: string = "";
	let bucketUrl: string = "";
	try {
		const outputUrl = body.output?.[0];

		if (!outputUrl) {
			throw new Error("No output URL found in the log");
		}

		const existingCounter = await c.var.db
			.select({ count: categoryCounters.count })
			.from(categoryCounters)
			.where(eq(categoryCounters.category, category!))
			.get();

		if (existingCounter) {
			updatedCount = existingCounter.count + 1;
			await c.var.db
				.update(categoryCounters)
				.set({ count: updatedCount })
				.where(eq(categoryCounters.category, category!))
				.execute();
		} else {
			updatedCount = 1;
			await c.var.db
				.insert(categoryCounters)
				.values({
					category: category!,
					count: updatedCount,
				})
				.execute();
		}
		const { fileName, url } = await downloadAndStoreImage(
			outputUrl,
			category!,
			c.env.BUCKET,
			updatedCount
		);
		const isFree = Math.floor(Math.random() * 4) === 0;

		await c.var.db
			.insert(wallpapers)
			.values({
				category: category!,
				filename: fileName,
				is_free: isFree ? 1 : 0,
			})
			.execute();

		bucketFilename = fileName;
		bucketUrl = url;

		return c.json({
			fileName: bucketFilename,
			url: bucketUrl,
			categoryCount: updatedCount,
		});
	} catch (error) {
		console.error("Error processing upscale request:", error);
		return c.json({ error: "Failed to process upscale request" }, 400);
	}
});

export default app;
