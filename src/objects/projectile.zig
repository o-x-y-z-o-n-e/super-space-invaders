const std = @import("std");
const rl = @import("raylib");
const ssi = @import("root");

const projectile = @This();

position: rl.Vector2,
velocity: rl.Vector2,
damage: f32,

pub fn create() !*projectile {
	var p = try std.heap.smp_allocator.create(projectile);
	p.position = rl.Vector2.init(0.0, 0.0);
	p.velocity = rl.Vector2.init(0.0, 0.0);
	p.damage = 10.0;
	return p;
}

pub fn destroy(p: *projectile) void {
	std.heap.smp_allocator.destroy(p);
}