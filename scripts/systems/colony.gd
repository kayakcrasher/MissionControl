extends Node

const MINE_RATE := 2.0       # units/sec while working
const HAUL_CAPACITY := 10.0
const WORK_TICKS := 2.0      # seconds of working before pickup

@onready var tasks: Node = get_node("../Tasks")
@onready var world: Node2D = get_node("../World")
@onready var resources: Node = get_node("../Resources")
@onready var robots_root: Node2D = get_node("../Robots")

var _work_timers: Dictionary = {}  # Robot -> float

func _process(delta: float) -> void:
for r in robots_root.get_children():
_tick_robot(r, delta)

func _tick_robot(r: Robot, delta: float) -> void:
if r.state == Robot.State.MOVING:
return

if r.carry > 0.0:
# hauling home
var base := tasks.base_tile
if r.tile == base:
resources.add(r.carry_kind, r.carry)
r.carry = 0.0
r.carry_kind = ""
tasks.clear(r)
r.state = Robot.State.IDLE
else:
if r.state != Robot.State.MOVING:
r.move_to(base, world.tiles)
return

# idle: pick up a job
var job: Dictionary = tasks.active_by_robot.get(r, {})
if job.is_empty():
var mt := tasks.take_mine()
if mt != Vector2i(-1, -1):
tasks.assign(r, tasks.Kind.MINE, mt)
r.move_to(mt, world.tiles)
return

match job.kind:
tasks.Kind.MINE:
if r.tile != job.tile:
if r.state != Robot.State.MOVING:
r.move_to(job.tile, world.tiles)
return
r.state = Robot.State.WORKING
var t: float = _work_timers.get(r, 0.0) + delta
_work_timers[r] = t
var res := _tile_resource(r.tile)
resources.add(res.kind, MINE_RATE * delta)
if t >= WORK_TICKS:
_work_timers[r] = 0.0
r.carry = HAUL_CAPACITY
r.carry_kind = res.kind
tasks.clear(r)
r.state = Robot.State.IDLE

func _tile_resource(t: Vector2i) -> Dictionary:
var terr: int = world.tiles.get(t, 0)
match terr:
world.Terrain.ICE:  return {"kind": "ice",     "rate": 1.2}
world.Terrain.ROCK: return {"kind": "metal",   "rate": 1.5}
world.Terrain.DUST: return {"kind": "silicon", "rate": 0.6}
_:                  return {"kind": "metal",   "rate": 0.8}
