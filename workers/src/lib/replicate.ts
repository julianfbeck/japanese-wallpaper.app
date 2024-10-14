import Replicate from "replicate";
import { Bindings } from "../core/workers";

// replicateLogStructure.ts

interface ReplicateInput {
	aspect_ratio: string;
	guidance: number;
	height: number;
	interval: number;
	output_format: string;
	output_quality: number;
	prompt: string;
	prompt_upsampling: boolean;
	safety_tolerance: number;
	steps: number;
	width: number;
}

interface ReplicateMetrics {
	image_count: number;
	predict_time: number;
}

interface ReplicateUrls {
	cancel: string;
	get: string;
	stream: string;
}

export interface ReplicateLogFlux {
	completed_at: string;
	created_at: string;
	data_removed: boolean;
	error: null | string;
	id: string;
	input: ReplicateInput;
	logs: string;
	metrics: ReplicateMetrics;
	model: string;
	output: string;
	started_at: string;
	status: string;
	urls: ReplicateUrls;
	version: string;
	webhook: string;
}

async function createWallpaper(
	env: Bindings,
	prompt: string,
	category: string
) {
	const escapedAndLowercasedCategory = category.toLowerCase();
	const replicate = new Replicate({ auth: env.REPLICATE_API_TOKEN });
	console.log("Running the model...");
	const input = {
		prompt: `Create a phone Wallpaper in following Category: ${category} Prompt: ${prompt}`,
		steps: 40,
		width: 662,
		height: 1440,
		// steps: 5,
		// width: 256,
		// height: 256,
		guidance: 3,
		interval: 2,
		aspect_ratio: "custom",
		output_format: "jpg",
		output_quality: 80,
		safety_tolerance: 2,
		prompt_upsampling: false,
	};
	await replicate.predictions.create({
		model: "black-forest-labs/flux-pro",
		input: input,
		webhook: `https://wallpaper-ai.beanvault.workers.dev/webhook/generated?category=${escapedAndLowercasedCategory}`,
		webhook_events_filter: ["completed"],
	});
}

async function upscaleWallpaper(env: Bindings, url: string, category: string) {
	const replicate = new Replicate({ auth: env.REPLICATE_API_TOKEN });
	console.log("Running the model...");
	const input = {
		seed: 1337,
		image: url,
		prompt:
			"masterpiece, best quality, highres, wallpaper, <lora:more_details:0.5> <lora:SDXLrender_v2.0:1>",
		dynamic: 6,
		handfix: "disabled",
		pattern: false,
		sharpen: 0,
		sd_model: "juggernaut_reborn.safetensors [338b85bc4f]",
		scheduler: "DPM++ 3M SDE Karras",
		creativity: 0.35,
		lora_links: "",
		downscaling: false,
		resemblance: 0.6,
		scale_factor: 2,
		tiling_width: 112,
		output_format: "jpg",
		tiling_height: 144,
		custom_sd_model: "",
		negative_prompt:
			"(worst quality, low quality, normal quality:2) JuggernautNegative-neg",
		num_inference_steps: 18,
		downscaling_resolution: 768,
	};
	replicate
		.run(
			"philz1337x/clarity-upscaler:dfad41707589d68ecdccd1dfa600d55a208f9310748e44bfe35b4a6291453d5e",
			{
				input: input,
				wait: false,
				webhook: `https://wallpaper-ai.beanvault.workers.dev/webhook/upscale?category=${category}`,
				webhook_events_filter: ["completed"],
			}
		)
		.then((response) => {})
		.catch((error) => {
			console.log(error);
		});

	await new Promise((resolve) => setTimeout(resolve, 400));
}

export { createWallpaper, upscaleWallpaper };
