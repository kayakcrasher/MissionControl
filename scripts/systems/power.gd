extends Node

signal changed()

const SOLAR_OUTPUT := 8.0
const DRILL_DRAW := 3.0
const STORAGE_DRAW := 0.5

var buildings: Array = []
var battery := 0.0
var battery_capacity := 200.0

func register(b: Building) -> void:
buildings.append(b)

func tick(delta: float, day_factor: float) -> void:
var gen := 0.0
var draw := 0.0
for b in buildings:
match b.kind:
Building.Kind.SOLAR:
gen += SOLAR_OUTPUT * day_factor
Building.Kind.DRILL:
draw += DRILL_DRAW
Building.Kind.STORAGE:
draw += STORAGE_DRAW
var net := (gen - draw) * delta
battery = clampf(battery + net, 0.0, battery_capacity)
changed.emit()

func has_power(amount: float) -> bool:
return battery >= amount

func consume(amount: float) -> bool:
if battery < amount: return false
battery -= amount
changed.emit()
return true
