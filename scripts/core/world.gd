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

var tiles: Dictionary = {}
var selected: Vector2i = Vector2i(-1, -1)

func _ready() -> void:
_generate()
clock.hour_changed.connect(_on_hour_changed)

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

func _on_hour_changed(_h: float) -> void:
queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
var t := cursor.hovered_tile
if tiles.has(t):
selected = Vector2i(-1, -1) if selected == t else t
cursor.selected = selected
queue_redraw()

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
