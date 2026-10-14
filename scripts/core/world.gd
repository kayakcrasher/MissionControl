extends Node2D

const GRID_W := 40
const GRID_H := 40
const HALF_W := Iso.TILE_W * 0.5
const HALF_H := Iso.TILE_H * 0.5

var _tiles: Dictionary = {}

func _ready() -> void:
_generate()

func _generate() -> void:
var rng := RandomNumberGenerator.new()
rng.seed = 12345
for y in GRID_H:
for x in GRID_W:
var r := rng.randf()
var col: Color
if r < 0.06:
col = Color(0.45, 0.20, 0.10)      # rock
elif r < 0.12:
col = Color(0.75, 0.85, 0.95)      # ice
elif r < 0.30:
col = Color(0.72, 0.35, 0.18)      # dust
else:
col = Color(0.80, 0.42, 0.22)      # regolith
_tiles[Vector2i(x, y)] = col

func _draw() -> void:
for coord in _tiles.keys():
var c: Color = _tiles[coord]
var center := Iso.tile_to_screen(coord.x, coord.y)
var pts := PackedVector2Array([
center + Vector2(0, -HALF_H),
center + Vector2(HALF_W, 0),
center + Vector2(0, HALF_H),
center + Vector2(-HALF_W, 0),
])
draw_colored_polygon(pts, c)
draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), Color(0, 0, 0, 0.25), 1.0)

func _process(_delta: float) -> void:
if Input.is_action_just_pressed("pan_up") or Input.is_action_just_pressed("pan_down"):
pass
# redraw only on demand
queue_redraw()
