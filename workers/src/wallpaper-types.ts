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
