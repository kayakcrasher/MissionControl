extends Node

enum Kind { NONE, MINE, HAUL, BUILD }

var current_kind: int = Kind.NONE
var current_tile: Vector2i = Vector2i(-1, -1)
var assigned_robot: Robot = null

signal changed()

func assign(kind: int, tile: Vector2i, robot: Robot) -> void:
current_kind = kind
current_tile = tile
assigned_robot = robot
changed.emit()

func clear() -> void:
current_kind = Kind.NONE
current_tile = Vector2i(-1, -1)
assigned_robot = null
changed.emit()
