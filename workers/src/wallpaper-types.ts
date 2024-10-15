export const WallpaperCategoryMap = new Map<string, string>([
	["nature", "Scenic nature landscapes, ultra-realistic, high definition"],
	["abstract", "Vibrant abstract patterns and designs"],
	["minimalist", "Clean and simple minimalist designs"],
	["cityscape", "Dynamic urban scenes and cityscapes"],
	["space", "Awe-inspiring space and celestial imagery"],
	["artistic", "Creative and expressive artistic illustrations"],
	["geometric", "Bold geometric shapes and patterns"],
	["textured", "Rich and detailed textured backgrounds"],
	["gradient", "Smooth and colorful gradient compositions"],
	["seasonal", "Seasonal themes and motifs, ultra-realistic, high definition"],
	["japanese", "Traditional and modern Japanese aesthetic designs"],
	["animals", "Diverse wildlife and animal portraits"],
	["architecture", "Striking architectural designs and structures"],
	["neon", "Vibrant neon lights and glowing effects"],
	["cute", "Adorable and charming cute designs"],
	["blackandwhite", "Elegant black and white compositions"],
	["halloween", "Spooky and festive Halloween themes"],
	["paint", "Artistic paint textures and brush strokes"],
	["apple", "Apple Inc. inspired designs, products, and brand aesthetics"],
	["anime", "Stylized anime and manga-inspired artwork"],
	["mesmerizing", "Hypnotic and captivating visual patterns"],
	["futuristiccities", "Imaginative futuristic cityscapes"],
	["liveilluminated", "Dynamic and illuminated live wallpapers"],
]);

export const getRandomDarkModeCategoryKey = () => {
	const categories = Array.from(JapaneseDarkModeWallpaperCategories.keys());
	return categories[Math.floor(Math.random() * categories.length)];
};

// Helper function to get the value for a dark mode category
export const getDarkModeCategoryValue = (key: string) => {
	return JapaneseDarkModeWallpaperCategories.get(key) || "Dark mode wallpaper";
};
export const JapaneseDarkModeWallpaperCategories = new Map<string, string>([
	[
		"yorunomachi",
		"Night cityscapes of Japan, neon-lit streets, and illuminated landmarks",
	],
	[
		"tsukimi",
		"Moon-viewing scenes, featuring the moon over traditional Japanese landscapes",
	],
	[
		"kagedoukutsu",
		"Shadowy abstract patterns inspired by traditional Japanese aesthetics",
	],
	[
		"youkaiworld",
		"Mysterious and ethereal scenes of Japanese folklore and supernatural creatures",
	],
	[
		"kurayami",
		"Minimalist designs emphasizing negative space and subtle, dark tones",
	],
	["gekkouen", "Nighttime Japanese gardens and nature scenes under moonlight"],
	[
		"denshipunk",
		"Futuristic, cyberpunk-inspired Japanese cityscapes with glowing elements",
	],
]);

export type WallpaperCategory = keyof typeof WallpaperCategoryMap;

export const wallpaperCategoryKeys: string[] = Array.from(
	WallpaperCategoryMap.keys()
);

/**
 * Returns a random category key from the WallpaperCategoryMap.
 * @returns {string} A random wallpaper category key
 */
export function getRandomCategoryKey(): string {
	const randomIndex = Math.floor(Math.random() * wallpaperCategoryKeys.length);
	return wallpaperCategoryKeys[randomIndex];
}

/**
 * Returns the UI-friendly value for a given category key.
 * @param {string} key - The category key
 * @returns {string} The UI-friendly category value
 */
export function getCategoryValue(key: string): string {
	return WallpaperCategoryMap.get(key.toLowerCase()) || key;
}
