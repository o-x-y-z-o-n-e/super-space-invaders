const std = @import("std");
const rl = @import("raylib");

const player = @This();

const textures = struct {
	var ship1Blue: ?rl.Texture2D = null;
	var ship1Green: ?rl.Texture2D = null;
	var ship1Orange: ?rl.Texture2D = null;
	var ship1Red: ?rl.Texture2D = null;
	var ship2Blue: ?rl.Texture2D = null;
	var ship2Green: ?rl.Texture2D = null;
	var ship2Orange: ?rl.Texture2D = null;
	var ship2Red: ?rl.Texture2D = null;
	var ship3Blue: ?rl.Texture2D = null;
	var ship3Green: ?rl.Texture2D = null;
	var ship3Orange: ?rl.Texture2D = null;
	var ship3Red: ?rl.Texture2D = null;
};

position: rl.Vector2,
model_variant: u32,
color_variant: u32,

pub fn init() !player {
	if(textures.ship1Blue == null) textures.ship1Blue = try rl.loadTexture("res/pack1/PNG/playerShip1_blue.png");
	if(textures.ship1Green == null) textures.ship1Green = try rl.loadTexture("res/pack1/PNG/playerShip1_green.png");
	if(textures.ship1Orange == null) textures.ship1Orange = try rl.loadTexture("res/pack1/PNG/playerShip1_orange.png");
	if(textures.ship1Red == null) textures.ship1Red = try rl.loadTexture("res/pack1/PNG/playerShip1_red.png");
	if(textures.ship2Blue == null) textures.ship2Blue = try rl.loadTexture("res/pack1/PNG/playerShip2_blue.png");
	if(textures.ship2Green == null) textures.ship2Green = try rl.loadTexture("res/pack1/PNG/playerShip2_green.png");
	if(textures.ship2Orange == null) textures.ship2Orange = try rl.loadTexture("res/pack1/PNG/playerShip2_orange.png");
	if(textures.ship2Red == null) textures.ship2Red = try rl.loadTexture("res/pack1/PNG/playerShip2_red.png");
	if(textures.ship3Blue == null) textures.ship3Blue = try rl.loadTexture("res/pack1/PNG/playerShip3_blue.png");
	if(textures.ship3Green == null) textures.ship3Green = try rl.loadTexture("res/pack1/PNG/playerShip3_green.png");
	if(textures.ship3Orange == null) textures.ship3Orange = try rl.loadTexture("res/pack1/PNG/playerShip3_orange.png");
	if(textures.ship3Red == null) textures.ship3Red = try rl.loadTexture("res/pack1/PNG/playerShip3_red.png");

	return player{
		.position = rl.Vector2.init(0.0, 0.0),
		.model_variant = 1,
		.color_variant = 3,
	};
}

pub fn update(self: *player, dt: f32) void {
	var move_input = rl.Vector2.init(0.0, 0.0);
	const speed = 128.0;
	if(rl.isKeyDown(.s)) {
		move_input.y = 1;
	}
	if(rl.isKeyDown(.w)) {
		move_input.y = -1;
	}
	if(rl.isKeyDown(.d)) {
		move_input.x = 1;
	}
	if(rl.isKeyDown(.a)) {
		move_input.x = -1;
	}
	move_input.x *= dt * speed;
	move_input.y *= dt * speed;
	self.move(move_input);
}

pub fn move(self: ?*player, delta: rl.Vector2) void {
	if(self) | s | {
		s.*.position = rl.Vector2.add(s.*.position, delta);
	}
}

pub fn draw(self: ?*player) void {
	if(self) | s | {
		const x = @as(i32, @intFromFloat(s.*.position.x));
		const y = @as(i32, @intFromFloat(s.*.position.y));
		const tint = rl.Color.white;
		const model = s.*.model_variant;
		const color = s.*.color_variant;
		switch(model) {
			0 => switch(color) {
				0 => { rl.drawTexture(textures.ship1Blue.?, x, y, tint); },
				1 => { rl.drawTexture(textures.ship1Green.?, x, y, tint); },
				2 => { rl.drawTexture(textures.ship1Orange.?, x, y, tint); },
				3 => { rl.drawTexture(textures.ship1Red.?, x, y, tint); },
				else => {}
			},
			1 => switch(color) {
				0 => { rl.drawTexture(textures.ship2Blue.?, x, y, tint); },
				1 => { rl.drawTexture(textures.ship2Green.?, x, y, tint); },
				2 => { rl.drawTexture(textures.ship2Orange.?, x, y, tint); },
				3 => { rl.drawTexture(textures.ship2Red.?, x, y, tint); },
				else => {}
			},
			2 => switch(color) {
				0 => { rl.drawTexture(textures.ship3Blue.?, x, y, tint); },
				1 => { rl.drawTexture(textures.ship3Green.?, x, y, tint); },
				2 => { rl.drawTexture(textures.ship3Orange.?, x, y, tint); },
				3 => { rl.drawTexture(textures.ship3Red.?, x, y, tint); },
				else => {}
			},
			else => {}
		}
		
	}
}