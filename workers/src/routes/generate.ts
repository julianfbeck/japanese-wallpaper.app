import { Hono } from "hono";
import OpenAI from "openai";
import { Bindings, Variables } from "../core/workers";
import { createWallpaper } from "../lib/replicate";
import { getCategoryValue, getRandomCategoryKey } from "../wallpaper-types";

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>();

app.get("/images", async (c) => {
	// Check if request has a query for the category, if not use random
	const categoryKey = c.req.query("category") || getRandomCategoryKey();
	const categoryValue = getCategoryValue(categoryKey);

	console.log("Category Key: ", categoryKey);
	console.log("Category Value: ", categoryValue);

	// List of categories that should have realistic keywords appended
	const realisticCategories = ["shizen", "tokai", "nihonchiri", "kenchiku"];

	// Keywords to append for realistic images
	const realisticKeywords =
		"ultra-realistic, high definition, photorealistic, detailed, 8K resolution";

	const client = new OpenAI({
		apiKey: c.env.OPENAI_API_KEY,
	});

	const chatCompletion = await client.chat.completions.create({
		messages: [
			{
				role: "system",
				content:
					"You are an expert AI specializing in creating unique and captivating prompts for wallpaper image generation, with a focus on Japanese themes and aesthetics. Your goal is to craft prompts that result in visually stunning, original, and highly detailed images perfect for desktop or mobile wallpapers. Consider current design trends, artistic techniques, and the specific category provided to create truly exceptional wallpapers.",
			},
			{
				role: "user",
				content: `Generate a unique and detailed prompt for a Japanese-themed wallpaper image based on the following category: "${categoryValue}". 
		  
		  Consider these aspects in your prompt:
		  1. Visual style (e.g., photorealistic, abstract, illustrated)
		  2. Color palette or mood
		  3. Composition and focal points
		  4. Textures and patterns
		  5. Lighting and atmosphere
		  6. Any unique elements that would make this wallpaper stand out
		  7. Japanese cultural elements or aesthetics relevant to the category
		  
		  Craft a prompt that will result in a wallpaper that's not only visually appealing but also original and captivating.
		  ${realisticCategories.includes(categoryKey) ? `Ensure the image is ${realisticKeywords}.` : ""}`,
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

export default app;
