extends Node

signal sol_changed(sol: int)
signal hour_changed(hour: float)

const SOL_LENGTH_SECONDS := 180.0
const HOURS_PER_SOL := 24.0

var sol := 1
var hour := 6.0
var paused := false

func _process(delta: float) -> void:
if paused: return
hour += (delta / SOL_LENGTH_SECONDS) * HOURS_PER_SOL
if hour >= HOURS_PER_SOL:
hour -= HOURS_PER_SOL
sol += 1
sol_changed.emit(sol)
hour_changed.emit(hour)

func day_factor() -> float:
var t := hour / HOURS_PER_SOL
return clampf(sin((t - 0.25) * TAU) * 0.5 + 0.5, 0.0, 1.0)
