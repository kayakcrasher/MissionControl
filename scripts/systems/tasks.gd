extends Node

signal changed()

enum Kind { NONE, MINE, HAUL_TO_BASE }

var pending_mine: Array = []      # Array[Vector2i]
var pending_haul: Array = []      # Array[Vector2i]
var base_tile: Vector2i = Vector2i(20, 20)
var active_by_robot: Dictionary = {}  # Robot -> {kind, tile, progress}

func enqueue_mine(t: Vector2i) -> void:
if not pending_mine.has(t):
pending_mine.append(t)
changed.emit()

func enqueue_haul(t: Vector2i) -> void:
if not pending_haul.has(t):
pending_haul.append(t)
changed.emit()

func take_mine() -> Vector2i:
if pending_mine.is_empty(): return Vector2i(-1, -1)
var t: Vector2i = pending_mine.pop_front()
changed.emit()
return t

func take_haul() -> Vector2i:
if pending_haul.is_empty(): return Vector2i(-1, -1)
var t: Vector2i = pending_haul.pop_front()
changed.emit()
return t

func assign(robot: Robot, kind: int, t: Vector2i) -> void:
active_by_robot[robot] = {"kind": kind, "tile": t, "progress": 0.0}

func clear(robot: Robot) -> void:
active_by_robot.erase(robot)

func has_task(robot: Robot) -> bool:
return active_by_robot.has(robot)
