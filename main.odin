package main

import "core:fmt"
import "core:time"
import sdl "vendor:sdl3"

main :: proc() {
	// Engine Initialization
	if !sdl.Init({.VIDEO}) {
		fmt.eprintln("SDL3 Init Fail")
		return
	}
	defer sdl.Quit()

	state.window = sdl.CreateWindow("RunePulse Engine", WINDOW_WIDTH, WINDOW_HEIGHT, {.RESIZABLE})
	state.renderer = sdl.CreateRenderer(state.window, nil)
	state.is_running = true
	
	last_time := time.now()

	// --- INITIALIZE GAME OBJECTS HERE ---

	for state.is_running {
		// Event Handling
		event: sdl.Event
		for sdl.PollEvent(&event) {
			if event.type == .QUIT do state.is_running = false
		}

		// Calculate Delta Time
		now := time.now()
		state.dt = f32(time.duration_seconds(time.since(last_time)))
		last_time = now

		// 1. Input
		update_input_state()

		// 2. Logic (Your Code Here)

		// 3. Engine Systems
		update_physics()
		draw_entities()

		sdl.Delay(1)
	}
}