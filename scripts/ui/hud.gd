extends CanvasLayer

var label: Label
var build_mode: int = -1

@onready var world: Node2D = get_node("../World")
@onready var resources: Node = get_node("../Resources")
@onready var power: Node = get_node("../Power")

func _ready() -> void:
label = Label.new()
label.position = Vector2(16, 12)
label.add_theme_color_override("font_color", Color(1, 1, 1))
label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
label.add_theme_constant_override("outline_size", 4)
add_child(label)

var hint := Label.new()
hint.position = Vector2(16, 96)
hint.text = "LMB select robot/tile | RMB move rover\n1 Solar  2 Drill  3 Storage  |  B place  ESC cancel"
hint.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
hint.add_theme_color_override("font_outline_color", Color(0, 0, 0))
hint.add_theme_constant_override("outline_size", 3)
add_child(hint)

resources.changed.connect(_refresh)
power.changed.connect(_refresh)
_refresh()

func _process(_d: float) -> void:
_update_label()

func _refresh() -> void:
_update_label()

func _update_label() -> void:
var r = resources.stock
var p = power.battery
label.text = "Sol %d  %02d:%02d\nMetal %d  Ice %d  Silicon %d\nPower %.0f/%.0f%s" % [
get_node("../Clock").sol,
int(get_node("../Clock").hour),
int(fmod(get_node("../Clock").hour, 1.0) * 60),
int(r.metal), int(r.ice), int(r.silicon),
p, power.battery_capacity,
"  [BUILD: %s]" % _build_name() if build_mode >= 0 else "",
]

func _build_name() -> String:
match build_mode:
0: return "SOLAR"
1: return "DRILL"
2: return "STORAGE"
return ""

func _unhandled_input(event: InputEvent) -> void:
if event is InputEventKey and event.pressed:
match event.keycode:
KEY_1: build_mode = Building.Kind.SOLAR
KEY_2: build_mode = Building.Kind.DRILL
KEY_3: build_mode = Building.Kind.STORAGE
KEY_ESCAPE: build_mode = -1
world.set_build_mode(build_mode)
_update_label()
