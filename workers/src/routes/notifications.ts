// index.ts

import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { sendNotification, SendNotificationRequest } from "../lib/apn";

const app = new Hono();

// Route Handler
app.post("/send", async (c) => {
	const request = await c.req.json<SendNotificationRequest>();

	if (!request.deviceToken || (!request.title && !request.body)) {
		throw new HTTPException(400, {
			message: "Device token and either title or body are required",
		});
	}

	try {
		const result = await sendNotification(request);
		return c.json(result);
	} catch (error) {
		console.error("Error sending notification:", error);
		throw new HTTPException(500, { message: "Failed to send notification" });
	}
});

export default app;
