package main

import sdl "vendor:sdl3"

WINDOW_WIDTH  :: 1280
WINDOW_HEIGHT :: 720

Collision_Layer :: enum u32 {
	None    = 0,
	Solid   = 1,
	Trigger = 2,
}

Entity :: struct {
	id:        int,
	active:    bool,
	type:      Collision_Layer,
	collides:  u32, 
	pos:       [2]f32,
	vel:       [2]f32,
	color:     [4]f32,
	// Vertices are relative to 'pos'
	vertices:  [dynamic][2]f32, 
}

State :: struct {
	window:     ^sdl.Window,
	renderer:   ^sdl.Renderer,
	is_running: bool,
	dt:         f32,
	entities:   [1024]Entity, 
	kbd_curr:   [^]bool,
	kbd_prev:   [512]bool,
}

state := State{}