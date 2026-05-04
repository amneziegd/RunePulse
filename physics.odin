package main

// Use linalg for vector math (dot, normalize, etc.)
import "core:math"
import "core:math/linalg"

update_physics :: proc() {
	for i in 0..<1024 {
		e := &state.entities[i]
		if !e.active || (e.vel.x == 0 && e.vel.y == 0) do continue

		// Basic movement
		e.pos += e.vel * state.dt

		// Collision Resolution
		for j in 0..<1024 {
			other := &state.entities[j]
			if !other.active || e.id == other.id do continue
			if (u32(other.type) & e.collides) == 0 do continue

			overlap, normal := check_polygon_collision(e, other)
			if overlap {
				// Push the entity out of the collision
				e.pos -= normal
				e.vel = {0, 0} 
			}
		}
	}
}

check_polygon_collision :: proc(a, b: ^Entity) -> (bool, [2]f32) {
	if len(a.vertices) < 3 || len(b.vertices) < 3 do return false, {0,0}

	overlap := f32(1e9)
	smallest_axis := [2]f32{0,0}

	get_world_verts :: proc(e: ^Entity) -> [dynamic][2]f32 {
		world := make([dynamic][2]f32, 0, len(e.vertices))
		for v in e.vertices do append(&world, v + e.pos)
		return world
	}

	verts_a := get_world_verts(a); defer delete(verts_a)
	verts_b := get_world_verts(b); defer delete(verts_b)

	polys := [2][dynamic][2]f32{verts_a, verts_b}
	for p in polys {
		for i in 0..<len(p) {
			p1 := p[i]
			p2 := p[(i + 1) % len(p)]
			
			edge := p2 - p1
			axis := [2]f32{-edge.y, edge.x} 
			
			// FIX: Use linalg.normalize for vectors
			axis = linalg.normalize(axis)

			min_a, max_a := project_polygon(verts_a, axis)
			min_b, max_b := project_polygon(verts_b, axis)

			if min_a >= max_b || min_b >= max_a do return false, {0,0}

			current_overlap := math.min(max_a, max_b) - math.max(min_a, min_b)
			if current_overlap < overlap {
				overlap = current_overlap
				smallest_axis = axis
			}
		}
	}

	d := verts_a[0] - verts_b[0]
	// FIX: Use linalg.dot for vectors
	if linalg.dot(d, smallest_axis) < 0 do smallest_axis = -smallest_axis

	return true, smallest_axis * overlap
}

project_polygon :: proc(verts: [dynamic][2]f32, axis: [2]f32) -> (f32, f32) {
	// FIX: Use linalg.dot here as well
	min := linalg.dot(verts[0], axis)
	max := min
	for i in 1..<len(verts) {
		p := linalg.dot(verts[i], axis)
		if p < min do min = p
		else if p > max do max = p
	}
	return min, max
}