class_name Building
extends Node2D

enum Kind { SOLAR, DRILL, STORAGE }

var kind: int
var tile: Vector2i
var footprint: Array = []
var sprite_color := Color.WHITE
var label := ""
var _t := 0.0

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

func _process(delta: float) -> void:
_t += delta
if kind == Kind.DRILL:
queue_redraw()

func _draw() -> void:
match kind:
Kind.SOLAR:   _draw_solar()
Kind.DRILL:   _draw_drill()
Kind.STORAGE: _draw_storage()

func _draw_solar() -> void:
var w := 22.0
var h := 12.0
var base := PackedVector2Array([
Vector2(0, -h),
Vector2(w, 0),
Vector2(0, h),
Vector2(-w, 0),
])
draw_colored_polygon(base, Color(0.35, 0.25, 0.20))
draw_polyline(PackedVector2Array([base[0], base[1], base[2], base[3], base[0]]), Color(0.08, 0.06, 0.05), 2.0)
# panel
var panel := PackedVector2Array([
Vector2(0, -h - 6),
Vector2(w - 4, -6),
Vector2(0, 6 - h + 12),
Vector2(-w + 4, -6),
])
draw_colored_polygon(panel, Color(0.20, 0.35, 0.60))
for i in range(-2, 3):
var x := i * 4.0
draw_line(Vector2(x, -h - 6 + abs(x) * 0.5), Vector2(x, -6 + abs(x) * 0.5), Color(0.08, 0.12, 0.25), 1.0)
draw_polyline(PackedVector2Array([panel[0], panel[1], panel[2], panel[3], panel[0]]), Color(0.05, 0.08, 0.20), 1.5)

func _draw_drill() -> void:
var w := 18.0
var h := 10.0
var base := PackedVector2Array([
Vector2(0, -h),
Vector2(w, 0),
Vector2(0, h),
Vector2(-w, 0),
])
draw_colored_polygon(base, Color(0.30, 0.20, 0.15))
draw_polyline(PackedVector2Array([base[0], base[1], base[2], base[3], base[0]]), Color(0.08, 0.06, 0.05), 2.0)
# tower
draw_rect(Rect2(-4, -22, 8, 14), Color(0.55, 0.55, 0.58))
draw_rect(Rect2(-4, -22, 8, 14), Color(0.10, 0.10, 0.12), false, 1.5)
# spinning bit
var ang := _t * 6.0
var bit_len := 6.0
draw_line(Vector2(0, -20), Vector2(cos(ang) * bit_len, -20 + sin(ang) * 2.0), Color(1.0, 0.5, 0.2), 2.0)
draw_circle(Vector2(0, -20), 2.0, Color(1.0, 0.7, 0.3))

func _draw_storage() -> void:
var w := 20.0
var h := 11.0
var base := PackedVector2Array([
Vector2(0, -h),
Vector2(w, 0),
Vector2(0, h),
Vector2(-w, 0),
])
draw_colored_polygon(base, Color(0.28, 0.45, 0.55))
draw_polyline(PackedVector2Array([base[0], base[1], base[2], base[3], base[0]]), Color(0.06, 0.10, 0.14), 2.0)
# lid
var lid := PackedVector2Array([
Vector2(0, -h - 4),
Vector2(w - 6, -4),
Vector2(0, h - 4),
Vector2(-w + 6, -4),
])
draw_colored_polygon(lid, Color(0.55, 0.75, 0.85))
draw_polyline(PackedVector2Array([lid[0], lid[1], lid[2], lid[3], lid[0]]), Color(0.10, 0.18, 0.22), 1.5)
