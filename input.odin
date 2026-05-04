package main

import sdl "vendor:sdl3"

update_input_state :: proc() {
	for i in 0..<512 {
		state.kbd_prev[i] = state.kbd_curr[i] if state.kbd_curr != nil else false
	}
	num_keys: i32
	state.kbd_curr = sdl.GetKeyboardState(&num_keys)
}

is_key_down :: proc(key: sdl.Scancode) -> bool {
	if state.kbd_curr == nil do return false
	return bool(state.kbd_curr[key])
}

is_key_pressed :: proc(key: sdl.Scancode) -> bool {
	if state.kbd_curr == nil do return false
	return bool(state.kbd_curr[key]) && !state.kbd_prev[key]
}