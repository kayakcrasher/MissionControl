extends Camera2D

@export var pan_speed := 600.0
@export var zoom_step := 0.1
@export var zoom_min := 0.3
@export var zoom_max := 3.0

var _dragging := false
var _drag_last := Vector2.ZERO

func _process(delta: float) -> void:
var dir := Vector2.ZERO
if Input.is_action_pressed("pan_up"):    dir.y -= 1
if Input.is_action_pressed("pan_down"):  dir.y += 1
if Input.is_action_pressed("pan_left"):  dir.x -= 1
if Input.is_action_pressed("pan_right"): dir.x += 1
if dir != Vector2.ZERO:
position += dir.normalized() * pan_speed * delta / zoom

func _unhandled_input(event: InputEvent) -> void:
if event is InputEventMouseButton:
if event.button_index == MOUSE_BUTTON_WHEEL_UP:
_zoom(-zoom_step)
elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
_zoom(zoom_step)
elif event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT:
_dragging = event.pressed
_drag_last = event.position

elif event is InputEventMouseMotion and _dragging:
position -= event.relative / zoom

elif event is InputEventScreenDrag:
position -= event.relative / zoom

func _zoom(delta_z: float) -> void:
var z := clampf(zoom.x + delta_z, zoom_min, zoom_max)
zoom = Vector2(z, z)
