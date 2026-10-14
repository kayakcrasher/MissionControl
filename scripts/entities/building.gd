class_name Building
extends Node2D

enum Kind { SOLAR, DRILL, STORAGE }

var kind: int
var tile: Vector2i
var footprint: Array = []
var sprite_color := Color.WHITE
var label := ""

func setup(k: int, t: Vector2i) -> void:
kind = k
tile = t
footprint = [t]
match kind:
Kind.SOLAR:
sprite_color = Color(0.95, 0.85, 0.20)
label = "SOLAR"
Kind.DRILL:
sprite_color = Color(0.85, 0.30, 0.25)
label = "DRILL"
Kind.STORAGE:
sprite_color = Color(0.30, 0.75, 0.85)
label = "STOR"
position = Iso.tile_to_screen(tile.x, tile.y)

func _draw() -> void:
var w := Iso.HALF_W * 0.7
var h := Iso.HALF_H * 0.9
var pts := PackedVector2Array([
Vector2(0, -h),
Vector2(w, 0),
Vector2(0, h),
Vector2(-w, 0),
])
draw_colored_polygon(pts, sprite_color)
draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), Color(0, 0, 0, 0.6), 1.5)
draw_line(Vector2(0, -h), Vector2(0, h), Color(0, 0, 0, 0.25), 1.0)
