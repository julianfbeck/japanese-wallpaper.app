CREATE TABLE `category_counters` (
	`category` text PRIMARY KEY NOT NULL,
	`count` integer DEFAULT 0 NOT NULL,
	`sorting` integer DEFAULT 0
);
--> statement-breakpoint
CREATE TABLE `wallpapers` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`category` text NOT NULL,
	`is_free` integer DEFAULT 0 NOT NULL,
	`downloads` integer DEFAULT 0 NOT NULL,
	`created_at` integer
);
--> statement-breakpoint
CREATE INDEX `category_idx` ON `wallpapers` (`category`);--> statement-breakpoint
CREATE INDEX `created_at_idx` ON `wallpapers` (`created_at`);