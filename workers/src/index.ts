import { Ai } from "@cloudflare/workers-types/experimental";
import { swaggerUI } from "@hono/swagger-ui";
import { Hono } from "hono";
import { basicAuth } from "hono/basic-auth";
import { DrizzleDB } from "./core/database";
import { Bindings, Variables } from "./core/workers";
import api from "./routes/api";
import dashboard from "./routes/dashboard";
import generate from "./routes/generate";
import notification from "./routes/notifications";
import webhook from "./routes/webhook";

const app = new Hono<{ Bindings: Bindings; Variables: Variables }>();

app.get("/", (c) => {
	return c.text("Hi");
});

// app.use(
//   "/internal/*",
//   basicAuth({
//     username: "beju",
//     password: "wnq!wyc4emu!EMT0pnt",
//   })

// );
app.get("/ui", swaggerUI({ url: "/api" }));

app.get("/internal/page", (c) => {
	return c.text("You are authorized");
});
app.use(async (ctx, next) => {
	ctx.set("db", DrizzleDB.getInstance(ctx.env.DB));
	await next();
});
app.route("generate", generate);

app.route("/webhook", webhook);

app.route("/api", api);
app.route("/notification", notification);

app.route("/dashboard", dashboard);

export default app;
