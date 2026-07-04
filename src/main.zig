const std = @import("std");
const rl = @import("raylib");
const ssi = @import("root");

pub const game = @import("game.zig");
pub const level = @import("level.zig");
pub const player = @import("objects/player.zig");
pub const projectile = @import("objects/projectile.zig");

pub fn main() !void {
    rl.initWindow(800, 600, "Super Space Invaders");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    try ssi.game.loadLevel(0);

    while(!rl.windowShouldClose()) {
        const dt = rl.getFrameTime();

        ssi.game.update(dt);
        
        rl.beginDrawing();
        rl.clearBackground(rl.Color.sky_blue);
        
        ssi.game.draw();

        rl.endDrawing();
    }


}