package main

import sdl "vendor:sdl3"

draw_entities :: proc() {
	sdl.SetRenderDrawColor(state.renderer, 20, 20, 25, 255)
	sdl.RenderClear(state.renderer)

	for i in 0..<1024 {
		e := &state.entities[i]
		if !e.active || len(e.vertices) < 2 do continue

		sdl.SetRenderDrawColor(state.renderer, u8(e.color.r*255), u8(e.color.g*255), u8(e.color.b*255), 255)

		for j in 0..<len(e.vertices) {
			v1 := e.vertices[j] + e.pos
			v2 := e.vertices[(j + 1) % len(e.vertices)] + e.pos
			sdl.RenderLine(state.renderer, v1.x, v1.y, v2.x, v2.y)
		}
	}
	sdl.RenderPresent(state.renderer)
}