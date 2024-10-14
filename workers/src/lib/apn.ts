// apn.ts

// APNs Configuration
const TEAM_ID = "VB9VC9U9AV";
const KEY_ID = "HKD8X86MMJ";
const BUNDLE_ID = "com.julianbeck.wallpaper-ai";
const PRIVATE_KEY = `-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgwZ/tV43uSQPIRdvN
IMLLP5MxxTLgjOzzzUQh+Uoj3tigCgYIKoZIzj0DAQehRANCAASaLgcJKHhhN2D/
JIbzx0KyXC2L3QEWAegAXSyamAikUY5sf2f4g9g480/H8bdWuJuO7MWVJVIo/zgy
KCo4Mfhu
-----END PRIVATE KEY-----`;

// Interfaces
export interface NotificationPayload {
	aps: {
		alert?: {
			title?: string;
			subtitle?: string;
			body?: string;
		};
		badge?: number;
		sound?: string | { critical?: number; name: string; volume?: number };
		"thread-id"?: string;
		category?: string;
		"content-available"?: 1;
		"mutable-content"?: 1;
		"target-content-id"?: string;
		"interruption-level"?: "passive" | "active" | "time-sensitive" | "critical";
	};
	[key: string]: any;
}

export interface SendNotificationRequest {
	deviceToken: string;
	title?: string;
	body?: string;
	badge?: number;
	sound?: string | { critical?: number; name: string; volume?: number };
	threadId?: string;
	category?: string;
	contentAvailable?: boolean;
	mutableContent?: boolean;
	targetContentId?: string;
	interruptionLevel?: "passive" | "active" | "time-sensitive" | "critical";
	customData?: { [key: string]: any };
}

// Helper Functions
function pemToArrayBuffer(pem: string): ArrayBuffer {
	const base64 = pem.replace(/-----[^-]+-----/g, "").replace(/\s/g, "");
	const binaryString = atob(base64);
	return Uint8Array.from(binaryString, (char) => char.charCodeAt(0)).buffer;
}

function arrayBufferToBase64(buffer: ArrayBuffer): string {
	return btoa(String.fromCharCode(...new Uint8Array(buffer)));
}

// Token Generation
async function generateToken(): Promise<string> {
	const header = { alg: "ES256", kid: KEY_ID };
	const payload = { iss: TEAM_ID, iat: Math.floor(Date.now() / 1000) };

	const encodedHeader = btoa(JSON.stringify(header)).replace(/=+$/, "");
	const encodedPayload = btoa(JSON.stringify(payload)).replace(/=+$/, "");

	const importedKey = await crypto.subtle.importKey(
		"pkcs8",
		pemToArrayBuffer(PRIVATE_KEY),
		{ name: "ECDSA", namedCurve: "P-256" },
		false,
		["sign"]
	);

	const signature = await crypto.subtle.sign(
		{ name: "ECDSA", hash: { name: "SHA-256" } },
		importedKey,
		new TextEncoder().encode(`${encodedHeader}.${encodedPayload}`)
	);

	const encodedSignature = arrayBufferToBase64(signature).replace(/=+$/, "");

	return `${encodedHeader}.${encodedPayload}.${encodedSignature}`
		.replace(/\+/g, "-")
		.replace(/\//g, "_");
}

// Notification Sending
export async function sendNotification(
	request: SendNotificationRequest
): Promise<{ success: boolean; status: number; statusText: string }> {
	const token = await generateToken();
	const notification: NotificationPayload = { aps: {} };

	if (request.title || request.body) {
		notification.aps.alert = {
			title: request.title,
			body: request.body,
		};
	}

	if (request.badge !== undefined) notification.aps.badge = request.badge;
	if (request.sound) notification.aps.sound = request.sound;
	if (request.threadId) notification.aps["thread-id"] = request.threadId;
	if (request.category) notification.aps.category = request.category;
	if (request.contentAvailable) notification.aps["content-available"] = 1;
	if (request.mutableContent) notification.aps["mutable-content"] = 1;
	if (request.targetContentId)
		notification.aps["target-content-id"] = request.targetContentId;
	if (request.interruptionLevel)
		notification.aps["interruption-level"] = request.interruptionLevel;

	// Add custom data
	if (request.customData) {
		Object.assign(notification, request.customData);
	}

	const response = await fetch(
		`https://api.sandbox.push.apple.com/3/device/${request.deviceToken}`,
		{
			method: "POST",
			headers: {
				Authorization: `Bearer ${token}`,
				"apns-topic": BUNDLE_ID,
				"apns-push-type": "alert",
			},
			body: JSON.stringify(notification),
		}
	);

	if (!response.ok) {
		throw new Error(
			`APNs request failed: ${response.status} ${response.statusText}`
		);
	}

	return {
		success: true,
		status: response.status,
		statusText: response.statusText,
	};
}
