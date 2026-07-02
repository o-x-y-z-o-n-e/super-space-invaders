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
		.max_speed = 600.0,
		.acceleration = 600.0,
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
	
	move(self, dt);

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

fn getTexture(self: *player) ?rl.Texture2D {
	const model = self.model_variant;
	const color = self.color_variant;
	return switch(model) {
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
}

fn getSize(self: *player) rl.Vector2 {
	const texture = getTexture(self);
	return rl.Vector2.init(
		@as(f32, @floatFromInt(texture.?.width)),
		@as(f32, @floatFromInt(texture.?.height))
	).scale(0.5);
}

pub fn draw(self: *player) void {
	const size = getSize(self);
	const texture = getTexture(self);
	const source = rl.Rectangle.init(
		0.0,
		0.0,
		@as(f32, @floatFromInt(texture.?.width)),
		@as(f32, @floatFromInt(texture.?.height))
	);
	const destination = rl.Rectangle.init(
		self.position.x,
		self.position.y,
		size.x - (@abs(self.velocity.x) / self.max_speed) * 16,
		size.y
	);
	const origin = rl.Vector2.init(
		destination.width / 2.0,
		destination.height / 2.0
	);

	rl.drawTexturePro(texture.?, source, destination, origin, 0.0, .white);
}

fn move(self: *player, dt: f32) void {
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
	self.position = rl.Vector2.add(self.position, self.velocity.scale(dt));

	const size = getSize(self);

	const x_min = size.x / 2.0;
	const y_min = size.y / 2.0;
	const x_max = @as(f32, @floatFromInt(ssi.game.getWidth())) - size.x / 2.0;
	const y_max = @as(f32, @floatFromInt(ssi.game.getHeight())) - size.y / 2.0;

	if(self.position.x < x_min) {
		self.position.x = x_min;
		self.velocity.x = 0.0;
	}
	if(self.position.y < y_min) {
		self.position.y = y_min;
		self.velocity.y = 0.0;
	}
	if(self.position.x > x_max) {
		self.position.x = x_max;
		self.velocity.x = 0.0;
	}
	if(self.position.y > y_max) {
		self.position.y = y_max;
		self.velocity.y = 0.0;
	}
}

fn shoot(self: *player) void {
	if(self.attack_cooldown > 0.0) return;

	self.attack_cooldown = self.attack_interval;

	// TODO: create projectile
	// TODO: sfx
}