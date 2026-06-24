const std = @import("std");
const rl = @import("raylib");
const ssi = @import("ssi.zig");

var currentLevelIndex: i32 = -1;
var player: ?ssi.player = null;

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
	player = try ssi.player.init();
}

pub fn update(dt: f32) void {
	ssi.player.update(&player.?, dt);
}

pub fn draw() void {
	ssi.player.draw(&player.?);
}