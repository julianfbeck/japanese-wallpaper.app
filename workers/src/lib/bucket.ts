import { v4 as uuidv4 } from "uuid";

function generateImgproxyUrl(imageUrl: string, maxWidth: number): string {
	const baseImgproxyUrl = "http://imageproxy.home.juli.sh/insecure";
	const resizeParams = `resize:fit:${maxWidth}:0`;
	return `${baseImgproxyUrl}/${resizeParams}/plain/${encodeURIComponent(imageUrl)}`;
}

export async function downloadAndStoreImage(
	imageUrl: string,
	category: string,
	bucket: R2Bucket,
	number: number,
	maxWidth: number = 672 / 2,
	maxHeight: number = 1440 / 2
): Promise<{ fileName: string; url: string }> {
	// Download the image
	const imageResponse = await fetch(imageUrl);
	if (!imageResponse.ok) {
		throw new Error(`Failed to fetch image: ${imageResponse.statusText}`);
	}
	const imageBuffer = await imageResponse.arrayBuffer();

	// Generate a unique filename
	const fileName = `${category}_${number.toString().padStart(5, "0")}`;
	const fileNameDownscaled = `${fileName}_downscaled.jpg`;

	// Save the downscaled image to R2
	// await bucket.put(fileNameDownscaled, downscaledImageBuffer, {});
	await bucket.put(fileName + ".jpg", imageBuffer, {
		customMetadata: { category },
	});

	//dowload the resized image
	const resizedImageUrl = generateImgproxyUrl(imageUrl, maxWidth);

	const resizedImageResponse = await fetch(resizedImageUrl);
	if (!resizedImageResponse.ok) {
		throw new Error(
			`Failed to fetch resized image: ${resizedImageResponse.statusText}`
		);
	}
	const resizedImageBuffer = await resizedImageResponse.arrayBuffer();
	await bucket.put(fileNameDownscaled, resizedImageBuffer, {
		customMetadata: { category },
	});

	// Return the filename and a placeholder URL
	// Replace 'https://your-r2-domain.com/' with your actual R2 public URL
	return {
		fileName,
		url: `https://your-r2-domain.com/${fileName}`,
	};
}
