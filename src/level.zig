const std = @import("std");
const rl = @import("raylib");
const ssi = @import("ssi.zig");

const level = @This();

const backgrounds = struct {
	var black: ?rl.Texture2D = null;
	var blue: ?rl.Texture2D = null;
	var darkPurple: ?rl.Texture2D = null;
	var purple: ?rl.Texture2D = null;
};

pub fn init() !void {
	if(backgrounds.black == null) backgrounds.black = try rl.loadTexture("res/kenney_space-shooter-remastered/Backgrounds/black.png");
	if(backgrounds.blue == null) backgrounds.blue = try rl.loadTexture("res/kenney_space-shooter-remastered/Backgrounds/blue.png");
	if(backgrounds.darkPurple == null) backgrounds.darkPurple = try rl.loadTexture("res/kenney_space-shooter-remastered/Backgrounds/darkPurple.png");
	if(backgrounds.purple == null) backgrounds.purple = try rl.loadTexture("res/kenney_space-shooter-remastered/Backgrounds/purple.png");
	
}

pub fn drawBackground() void {
	const tex: ?rl.Texture2D = backgrounds.black;
	const tw = @as(i32, tex.?.width);
	const th = @as(i32, tex.?.height);
	const rx = @divFloor(ssi.game.getWidth() + tw - 1, tw);
	const ry = @divFloor(ssi.game.getHeight() + th - 1, th);

	var px: i32 = 0;
	while(px < rx) {
		var py: i32 = 0;
		while(py < ry) {
			rl.drawTexture(tex.?, px * tw, py * th, .white);
			py += 1;
		}
		px += 1;
	}
}