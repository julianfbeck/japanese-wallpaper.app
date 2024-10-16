export const WallpaperCategoryMap = new Map<string, string>([
	[
		"shizen",
		"Serene Japanese nature scenes, including cherry blossoms, Mount Fuji, and zen gardens",
	],
	["ukiyoe", "Traditional ukiyo-e style artwork and woodblock prints"],
	["minimaru", "Minimalist designs inspired by Japanese aesthetics"],
	[
		"tokai",
		"Modern Japanese cityscapes, including Tokyo skylines and neon-lit streets",
	],
	["uchuu", "Space and celestial imagery with a Japanese artistic twist"],
	["sumieart", "Expressive sumi-e (ink wash painting) inspired illustrations"],
	["origami", "Geometric patterns and designs based on origami art"],
	[
		"washi",
		"Textured backgrounds reminiscent of traditional Japanese washi paper",
	],
	["nihonga", "Contemporary Japanese-style paintings (Nihonga)"],
	["kisetsu", "Seasonal themes reflecting Japan's four distinct seasons"],
	[
		"dentoubunka",
		"Traditional Japanese cultural elements like kimonos, tea ceremonies, and festivals",
	],
	["nihonchiri", "Diverse landscapes showcasing Japan's geographical beauty"],
	["kenchiku", "Traditional and modern Japanese architectural designs"],
	["neonwaku", "Cyberpunk-inspired neon cityscapes with a Japanese flair"],
	["kawaii", "Cute and charming designs in the kawaii style"],
	[
		"monokuro",
		"Elegant black and white compositions inspired by ink paintings",
	],
	["youkai", "Mythical Japanese creatures and folklore-inspired themes"],
	["mizuiro", "Watercolor-style paintings with a Japanese aesthetic"],
	["anime", "Popular anime and manga-inspired artwork"],
	["shodo", "Mesmerizing patterns based on Japanese calligraphy"],
	["mirai", "Futuristic Japanese cityscapes and technology concepts"],
	[
		"kineticart",
		"Dynamic and animated designs inspired by Japanese kinetic art",
	],
	["wagara", "Traditional Japanese patterns and motifs"],
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
