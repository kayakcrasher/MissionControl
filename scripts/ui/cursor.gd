extends Node2D

var hovered_tile: Vector2i = Vector2i(-1, -1)
var selected: Vector2i = Vector2i(-1, -1)

@onready var camera: Camera2D = get_node("../Camera2D")

func _process(_delta: float) -> void:
hovered_tile = camera.hovered_tile()
queue_redraw()

func _draw() -> void:
if hovered_tile == Vector2i(-1, -1): return
var c := Iso.tile_to_screen(hovered_tile.x, hovered_tile.y)
var pts := Iso.tile_diamond(c)
draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), Color(1, 0.9, 0.4, 0.6), 1.5)
