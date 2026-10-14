extends Node

signal changed()

var stock := {
"metal": 0,
"ice": 0,
"silicon": 0,
"power": 100.0,
}

func add(kind: String, amount: float) -> void:
if not stock.has(kind): return
stock[kind] += amount
changed.emit()

func take(kind: String, amount: float) -> bool:
if not stock.has(kind): return false
if stock[kind] < amount: return false
stock[kind] -= amount
changed.emit()
return true

func get_amount(kind: String) -> float:
return stock.get(kind, 0.0)
