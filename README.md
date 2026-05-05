# 🌀 RunePulse Engine
**A Genre-Agnostic 2D Engine Template for Odin + SDL3.**

RunePulse is designed for developers who want a "Scenario-Proof" foundation. It handles the complex math of polygon collisions and input buffering, leaving you free to define the rules of your world.

---

## 🧠 The Mental Model
To master RunePulse, you must understand how data flows through the engine. You don't "create" objects; you **activate** data slots.

### 1. The "Parking Lot" (Entity Management)
The engine pre-allocates **1,024 slots** for entities. 
*   **Inactive Slots:** The engine ignores these. They cost zero processing power.
*   **Active Slots:** When you set `active = true`, the engine pulls that slot into the Physics and Render systems.



### 2. The "Assembly Line" (Game Loop)
Every frame (calculated via Delta Time `dt`) follows this order:
1.  **Input:** The engine captures what keys are being pressed or tapped.
2.  **Your Logic:** This is the ONLY part you edit. You change the `velocity` of entities based on input.
3.  **Physics (SAT):** The engine moves entities and resolves collisions.
4.  **Render:** The engine draws the final positions to the screen.

---

## 🛠️ Data Reference

### Entity Properties
| Property | Type | Description |
| :--- | :--- | :--- |
| `active` | `bool` | Must be `true` to exist in the world. |
| `pos` | `[2]f32` | The center/anchor point of the entity. |
| `vel` | `[2]f32` | Speed in pixels per second. **Always multiply by `dt`!** |
| `vertices` | `[dynamic]` | The points that form the shape (must be convex). |
| `type` | `Enum` | Set to `.Solid` to make it a physical wall. |

---

## ⚡ The Physics: SAT Collision
RunePulse uses **Separating Axis Theorem (SAT)**. Imagine shining a flashlight on two shapes from different angles. If there is ever a gap in their shadows, they are not touching. If no gap exists on any axis, the engine pushes them apart.



**The Rule:** Your polygons must be **convex** (no "dents" or "caves" in the shape).

---

## ⌨️ Input System
| Function | Use Case |
| :--- | :--- |
| `is_key_down()` | Continuous movement (e.g., walking, thrusting). |
| `is_key_pressed()` | Single actions (e.g., jumping, shooting, menus). |

---

## 🚀 Creating Your First Entity
Add this to your "Initialize" section in `main.odin`:

```odin
// 1. Grab a slot
p := &state.entities[0]
p.active = true
p.pos = {400, 300}
p.color = {0.2, 0.8, 0.3, 1.0}

// 2. Define the shape (a simple square)
append(&p.vertices, [2]f32{-25, -25}, [2]f32{25, -25}, [2]f32{25, 25}, [2]f32{-25, 25})

// 3. Move it (Inside the loop)
if is_key_down(.D) do p.vel.x = 500
