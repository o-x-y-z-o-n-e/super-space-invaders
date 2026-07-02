const std = @import("std");
const rl = @import("raylib");
const ssi = @import("../ssi.zig");

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

max_speed: f32,
acceleration: f32,
velocity: rl.Vector2,
position: rl.Vector2,
model_variant: u32,
color_variant: u32,
health_max: u32,
health: u32,
attack_cooldown: f32,
attack_interval: f32,

pub fn init() !player {
	if(textures.ship1Blue == null) textures.ship1Blue = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip1_blue.png");
	if(textures.ship1Green == null) textures.ship1Green = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip1_green.png");
	if(textures.ship1Orange == null) textures.ship1Orange = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip1_orange.png");
	if(textures.ship1Red == null) textures.ship1Red = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip1_red.png");
	if(textures.ship2Blue == null) textures.ship2Blue = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip2_blue.png");
	if(textures.ship2Green == null) textures.ship2Green = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip2_green.png");
	if(textures.ship2Orange == null) textures.ship2Orange = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip2_orange.png");
	if(textures.ship2Red == null) textures.ship2Red = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip2_red.png");
	if(textures.ship3Blue == null) textures.ship3Blue = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip3_blue.png");
	if(textures.ship3Green == null) textures.ship3Green = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip3_green.png");
	if(textures.ship3Orange == null) textures.ship3Orange = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip3_orange.png");
	if(textures.ship3Red == null) textures.ship3Red = try rl.loadTexture("res/kenney_space-shooter-remastered/PNG/playerShip3_red.png");

	return player{
		.max_speed = 10.0,
		.acceleration = 10.0,
		.velocity = rl.Vector2.init(0.0, 0.0),
		.position = rl.Vector2.init(0.0, 0.0),
		.model_variant = 1,
		.color_variant = 3,
		.health_max = 100,
		.health = 100,
		.attack_cooldown = 0.0,
		.attack_interval = 0.3,
	};
}

pub fn update(self: *player, dt: f32) void {
	var move_input = rl.Vector2.init(0.0, 0.0);

	if(rl.isKeyDown(.s) or rl.isKeyDown(.down)) {
		move_input.y = 1;
	}
	if(rl.isKeyDown(.w) or rl.isKeyDown(.up)) {
		move_input.y = -1;
	}
	if(rl.isKeyDown(.d) or rl.isKeyDown(.right)) {
		move_input.x = 1;
	}
	if(rl.isKeyDown(.a) or rl.isKeyDown(.left)) {
		move_input.x = -1;
	}

	var target_velocity = rl.Vector2.init(move_input.x, move_input.y);
	target_velocity = rl.Vector2.scale(target_velocity, self.max_speed);

	self.velocity = rl.Vector2.moveTowards(self.velocity, target_velocity, dt * self.acceleration);

	self.move(self.velocity);

	if(self.position.x < 0.0) {
		self.position.x = 0.0;
	}
	if(self.position.y < 0.0) {
		self.position.y = 0.0;
	}

	if(self.position.x > @as(f32, @floatFromInt(ssi.game.getWidth()))) {
		self.position.x = @as(f32, @floatFromInt(ssi.game.getWidth()));
	}
	if(self.position.y > @as(f32, @floatFromInt(ssi.game.getHeight()))) {
		self.position.y = @as(f32, @floatFromInt(ssi.game.getHeight()));
	}

	if(self.attack_cooldown > 0.0) {
		self.attack_cooldown -= dt;
		if(self.attack_cooldown <= 0.0) {
			self.attack_cooldown = 0.0;
		}
	}

	if(rl.isKeyDown(.space)) {
		self.shoot();
	}
}

pub fn draw(self: *player) void {
	const model = self.model_variant;
	const color = self.color_variant;
	const texture: ?rl.Texture2D = switch(model) {
		0 => switch(color) {
			0 => textures.ship1Blue,
			1 => textures.ship1Green,
			2 => textures.ship1Orange,
			3 => textures.ship1Red,
			else => null
		},
		1 => switch(color) {
			0 => textures.ship2Blue,
			1 => textures.ship2Green,
			2 => textures.ship2Orange,
			3 => textures.ship2Red,
			else => null
		},
		2 => switch(color) {
			0 => textures.ship3Blue,
			1 => textures.ship3Green,
			2 => textures.ship3Orange,
			3 => textures.ship3Red,
			else => null
		},
		else => null
	};
	const w = @as(f32, @floatFromInt(texture.?.width));
	const h = @as(f32, @floatFromInt(texture.?.height));
	const source = rl.Rectangle.init(0.0, 0.0, w, h);
	const destination = rl.Rectangle.init(self.position.x, self.position.y, w / 2.0, h / 2.0);
	const origin = rl.Vector2.init(destination.width / 2.0, destination.height / 4.0);
	rl.drawTexturePro(texture.?, source, destination, origin, 0.0, rl.Color.white);
}

fn move(self: *player, delta: rl.Vector2) void {
	self.position = rl.Vector2.add(self.position, delta);
}

fn shoot(self: *player) void {
	if(self.attack_cooldown > 0.0) return;

	self.attack_cooldown = self.attack_interval;

	// TODO: ceate projectile
	// TODO: sfx
}