class_name Robot
extends Node2D

enum State { IDLE, MOVING, WORKING }

var tile: Vector2i = Vector2i(0, 0)
var state: int = State.IDLE
var path: Array = []
var speed_tiles_per_sec := 1.0
var _move_progress := 0.0
var selected := false

var body_color := Color(0.9, 0.8, 0.2)
var outline_color := Color(0.08, 0.06, 0.05)

var carry := 0.0
var carry_kind := ""

func setup(start_tile: Vector2i) -> void:
tile = start_tile
position = Iso.tile_to_screen(tile.x, tile.y)

func move_to(target: Vector2i, tiles: Dictionary) -> void:
path = Pathfinding.find_path(tile, target, tiles)
_move_progress = 0.0
if path.is_empty():
state = State.IDLE
else:
state = State.MOVING
queue_redraw()

func _process(delta: float) -> void:
if state == State.MOVING:
_move_progress += delta * speed_tiles_per_sec
while _move_progress >= 1.0 and not path.is_empty():
_move_progress -= 1.0
tile = path.pop_front()
if path.is_empty():
state = State.IDLE
_move_progress = 0.0
break
if state == State.MOVING and not path.is_empty():
var next: Vector2i = path[0]
var a := Iso.tile_to_screen(tile.x, tile.y)
var b := Iso.tile_to_screen(next.x, next.y)
position = a.lerp(b, _move_progress)
else:
position = Iso.tile_to_screen(tile.x, tile.y)
queue_redraw()

func _draw() -> void:
# body chassis — iso diamond shape
var w := 9.0
var h := 6.0
var chassis := PackedVector2Array([
Vector2(0, -h),
Vector2(w, 0),
Vector2(0, h),
Vector2(-w, 0),
])
draw_colored_polygon(chassis, body_color)
draw_polyline(PackedVector2Array([chassis[0], chassis[1], chassis[2], chassis[3], chassis[0]]), outline_color, 2.0)

# solar panel on top
var panel := PackedVector2Array([
Vector2(-6, -3),
Vector2(6, -3),
Vector2(6, 0),
Vector2(-6, 0),
])
draw_colored_polygon(panel, Color(0.15, 0.30, 0.55))
draw_polyline(PackedVector2Array([panel[0], panel[1], panel[2], panel[3], panel[0]]), Color(0.05, 0.10, 0.25), 1.0)
draw_line(Vector2(0, -3), Vector2(0, 0), Color(0.05, 0.10, 0.25, 0.6), 1.0)

# antenna
draw_line(Vector2(4, -3), Vector2(6, -9), outline_color, 1.5)
draw_circle(Vector2(6, -9), 1.5, Color(1, 0.4, 0.3))

# carry indicator
if carry > 0.0:
draw_circle(Vector2(-6, -6), 3.0, Color(0.9, 0.9, 0.9))
draw_arc(Vector2(-6, -6), 3.0, 0, TAU, 12, outline_color, 1.0)
