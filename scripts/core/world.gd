extends Node2D

enum Terrain { REGOLITH, DUST, ROCK, ICE }

const GRID_W := 40
const GRID_H := 40

const COLORS := {
Terrain.REGOLITH: Color(0.80, 0.42, 0.22),
Terrain.DUST:     Color(0.72, 0.35, 0.18),
Terrain.ROCK:     Color(0.45, 0.20, 0.10),
Terrain.ICE:      Color(0.75, 0.85, 0.95),
}

@onready var clock: Node = get_node("../Clock")
@onready var cursor: Node2D = get_node("../Cursor")
@onready var robots_root: Node2D = get_node("../Robots")
@onready var camera: Camera2D = get_node("../Camera2D")

var tiles: Dictionary = {}
var selected: Vector2i = Vector2i(-1, -1)
var selected_robot: Robot = null

func _ready() -> void:
_generate()
clock.hour_changed.connect(_on_hour_changed)
_spawn_rover(Vector2i(15, 20))

func _generate() -> void:
var rng := RandomNumberGenerator.new()
rng.seed = 12345
for y in GRID_H:
for x in GRID_W:
var r := rng.randf()
var t: Terrain
if r < 0.06: t = Terrain.ROCK
elif r < 0.12: t = Terrain.ICE
elif r < 0.30: t = Terrain.DUST
else: t = Terrain.REGOLITH
tiles[Vector2i(x, y)] = t

func _spawn_rover(at: Vector2i) -> void:
var r := Robot.new()
r.set_script(load("res://scripts/entities/rover.gd"))
robots_root.add_child(r)
r.setup(at)

func _on_hour_changed(_h: float) -> void:
queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
var t := cursor.hovered_tile
var hit := _robot_at_screen(camera.screen_to_world(event.position))
if hit:
_select_robot(hit)
elif tiles.has(t):
selected = Vector2i(-1, -1) if selected == t else t
cursor.selected = selected
_clear_robot_selection()
queue_redraw()

elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
if selected_robot:
var t := cursor.hovered_tile
if tiles.has(t):
selected_robot.move_to(t, tiles)

func _robot_at_screen(world: Vector2) -> Robot:
for r in robots_root.get_children():
if world.distance_to(r.position) <= 14.0:
return r
return null

func _select_robot(r: Robot) -> void:
_clear_robot_selection()
selected_robot = r
r.selected = true
r.queue_redraw()

func _clear_robot_selection() -> void:
if selected_robot:
selected_robot.selected = false
selected_robot.queue_redraw()
selected_robot = null

func _draw() -> void:
var light := clock.day_factor()
var tint := Color(1, 0.85, 0.7).lerp(Color(0.15, 0.18, 0.30), 1.0 - light)
for coord in tiles.keys():
var base: Color = COLORS[tiles[coord]]
var col := base * tint
var c := Iso.tile_to_screen(coord.x, coord.y)
var pts := Iso.tile_diamond(c)
draw_colored_polygon(pts, col)
draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), Color(0, 0, 0, 0.2), 1.0)
if coord == selected:
var s := Iso.tile_diamond(c)
draw_polyline(PackedVector2Array([s[0], s[1], s[2], s[3], s[0]]), Color(1, 1, 1, 0.95), 2.0)
