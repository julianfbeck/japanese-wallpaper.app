import { Hono } from "hono";
import { html } from "hono/html";
import { Bindings, Variables } from "../core/workers";
import { categoryCounters } from "../models/models";
import type { FC } from "hono/jsx";

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>();

const Layout: FC = (props) => {
	return (
		<html>
			<head>
				<title>Wallpaper Generator</title>
				{html`
					<script>
						document.addEventListener("DOMContentLoaded", () => {
							document
								.querySelectorAll(".generate-image-btn")
								.forEach((btn) => {
									btn.addEventListener("click", async (e) => {
										const category = e.target.dataset.category;
										const btn = e.target;
										btn.disabled = true;
										btn.textContent = "Generating...";

										try {
											const response = await fetch(
												"/internal/generate/images?category=" +
													encodeURIComponent(category),
												{
													method: "GET",
													headers: {
														Accept: "application/json",
													},
												}
											);

											if (!response.ok) {
												throw new Error("Network response was not ok");
											}

											const data = await response.json();
											alert(
												"Image generated successfully! Prompt: " + data.content
											);
										} catch (error) {
											console.error("Error:", error);
											alert("Failed to generate image. Please try again.");
										} finally {
											btn.disabled = false;
											btn.textContent = "Generate Image";
										}
									});
								});
						});
					</script>
				`}
			</head>
			<body>{props.children}</body>
		</html>
	);
};

type Category = {
	category: string;
	count: number;
};

const Top: FC<{ categories: Category[] }> = (props) => {
	return (
		<Layout>
			<h2>Categories:</h2>
			<ul>
				{props.categories.map((cat) => (
					<li>
						{cat.category}: {cat.count}
						<button class="generate-image-btn" data-category={cat.category}>
							Generate Image
						</button>
					</li>
				))}
			</ul>
		</Layout>
	);
};

app.get("/", async (c) => {
	const categories = await c.var.db.select().from(categoryCounters);
	return c.html(<Top categories={categories} />);
});

export default app;
