class_name Pathfinding
extends RefCounted

const NEIGHBORS := [
Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(0, 1), Vector2i(0, -1),
]

static func find_path(start: Vector2i, goal: Vector2i, tiles: Dictionary) -> Array:
if start == goal: return []
if not tiles.has(start) or not tiles.has(goal): return []

var open := [start]
var came_from := {}
var g := {start: 0}
var f := {start: _h(start, goal)}

while not open.is_empty():
var current: Vector2i = open[0]
var best := f.get(current, 999999)
for n in open:
var nf = f.get(n, 999999)
if nf < best:
best = nf
current = n
open.erase(current)

if current == goal:
return _reconstruct(came_from, current)

for d in NEIGHBORS:
var nb: Vector2i = current + d
if not tiles.has(nb): continue
var tentative = g.get(current, 0) + 1
if tentative < g.get(nb, 999999):
came_from[nb] = current
g[nb] = tentative
f[nb] = tentative + _h(nb, goal)
if not open.has(nb):
open.append(nb)
return []

static func _h(a: Vector2i, b: Vector2i) -> int:
return abs(a.x - b.x) + abs(a.y - b.y)

static func _reconstruct(came_from: Dictionary, current: Vector2i) -> Array:
var path := [current]
while came_from.has(current):
current = came_from[current]
path.append(current)
path.reverse()
path.pop_front()
return path
