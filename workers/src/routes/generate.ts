import { Hono } from "hono";
import OpenAI from "openai";
import { Bindings, Variables } from "../core/workers";
import { createWallpaper } from "../lib/replicate";
import {
	getCategoryValue,
	getDarkModeCategoryValue,
	getRandomCategoryKey,
	getRandomDarkModeCategoryKey,
	JapaneseDarkModeWallpaperCategories,
} from "../wallpaper-types";

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>();

app.get("/light", async (c) => {
	const categoryKey = c.req.query("category") || getRandomCategoryKey();
	const categoryValue = getCategoryValue(categoryKey);

	console.log("Category Key: ", categoryKey);
	console.log("Category Value: ", categoryValue);

	const client = new OpenAI({
		apiKey: c.env.OPENAI_API_KEY,
	});

	const chatCompletion = await client.chat.completions.create({
		messages: [
			{
				role: "system",
				content: "Create concise, vivid prompts for Japanese-style wallpapers.",
			},
			{
				role: "user",
				content: `Generate a brief, detailed prompt for a Japanese-style wallpaper based on: "${categoryValue}". Include visual style, colors, and unique elements. This is for a Japanese wallpaper generator app.`,
			},
		],
		model: "gpt-4",
	});

	const promptContent = chatCompletion.choices[0]?.message?.content;

	if (promptContent) {
		await createWallpaper(c.env, promptContent, categoryKey);
	} else {
		console.error("No prompt content generated");
	}

	return c.json(chatCompletion.choices[0]?.message);
});

app.get("/dark", async (c) => {
	const categoryKey = c.req.query("category") || getRandomDarkModeCategoryKey();
	const categoryValue = getDarkModeCategoryValue(categoryKey);

	console.log("Dark Mode Category Key: ", categoryKey);
	console.log("Dark Mode Category Value: ", categoryValue);

	const client = new OpenAI({
		apiKey: c.env.OPENAI_API_KEY,
	});

	const chatCompletion = await client.chat.completions.create({
		messages: [
			{
				role: "system",
				content:
					"Create concise, vivid prompts for Japanese-style dark mode wallpapers.",
			},
			{
				role: "user",
				content: `Generate a brief, detailed prompt for a Japanese-style dark mode wallpaper based on: "${categoryValue}". Focus on dark palette, contrast, and mood. This is for a Japanese wallpaper generator app.`,
			},
		],
		model: "gpt-4",
	});

	const promptContent = chatCompletion.choices[0]?.message?.content;
	if (promptContent) {
		await createWallpaper(c.env, promptContent, categoryKey);
	} else {
		console.error("No prompt content generated for dark mode wallpaper");
	}

	return c.json(chatCompletion.choices[0]?.message);
});

export default app;
