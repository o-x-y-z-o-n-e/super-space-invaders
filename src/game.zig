const std = @import("std");
const rl = @import("raylib");
const ssi = @import("ssi.zig");

const width: i32 = 800;
const height: i32 = 600;

var currentLevelIndex: i32 = -1;
var player: ?ssi.player = null;

pub fn getWidth() i32 {
	return width;
}

pub fn getHeight() i32 {
	return height;
}

pub fn loadMainMenu() void {

	currentLevelIndex = -1;
	player = null;
}

pub fn loadLevel(levelIndex: i32) !void {
	if(levelIndex < 0) {
		loadMainMenu();
		return;
	}

	currentLevelIndex = levelIndex;
	try ssi.level.init();

	try spawnPlayer();
}

pub fn update(dt: f32) void {
	ssi.player.update(&player.?, dt);
}

pub fn draw() void {
	ssi.level.drawBackground();
	ssi.player.draw(&player.?);
}

fn spawnPlayer() !void {
	player = try ssi.player.init();
	player.?.position = rl.Vector2.init(
		@as(f32, @floatFromInt(width)) / 2.0,
		@as(f32, @floatFromInt(height)) - 100.0
	);
}