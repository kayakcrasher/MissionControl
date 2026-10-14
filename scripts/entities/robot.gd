class_name Robot
extends Node2D

enum State { IDLE, MOVING }

var tile: Vector2i = Vector2i(0, 0)
var state: int = State.IDLE
var path: Array = []
var speed_tiles_per_sec := 1.0
var _move_progress := 0.0
var selected := false

var body_color := Color(0.9, 0.8, 0.2)
var outline_color := Color(0.1, 0.1, 0.1)

func setup(start_tile: Vector2i) -> void:
tile = start_tile
position = Iso.tile_to_screen(tile.x, tile.y)

func move_to(target: Vector2i, tiles: Dictionary) -> void:
path = Pathfinding.find_path(tile, target, tiles)
_move_progress = 0.0
state = State.MOVING if not path.is_empty() else State.IDLE
queue_redraw()

func _process(delta: float) -> void:
if state != State.MOVING: return
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
var r := 10.0
draw_circle(Vector2.ZERO, r, body_color)
draw_arc(Vector2.ZERO, r, 0, TAU, 24, outline_color, 2.0)
if selected:
draw_arc(Vector2.ZERO, r + 6, 0, TAU, 32, Color(1, 1, 1, 0.95), 2.0)
