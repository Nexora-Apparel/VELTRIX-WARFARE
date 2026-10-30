extends Node2D
class_name VeltrixMobileControls

## Lightweight multi-touch controls. Left thumb moves; right thumb looks.
## Bottom-right buttons provide jump, sprint and crouch.

var _move_touch := -1
var _look_touch := -1
var _sprint_touch := -1
var _crouch_touch := -1
var _move_vector := Vector2.ZERO
var _look_delta := Vector2.ZERO
var _jump_requested := false
var _fire_requested := false
var _reload_requested := false
var _sprint := false
var _crouch := false
var _viewport_size := Vector2.ZERO
var _joystick_center := Vector2.ZERO
var _joystick_radius := 92.0

func _ready() -> void:
	_viewport_size = get_viewport_rect().size
	_joystick_center = Vector2(132.0, _viewport_size.y - 132.0)
	set_process_input(true)
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_viewport_size = get_viewport_rect().size
		_joystick_center = Vector2(132.0, _viewport_size.y - 132.0)
		queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _inside_button(event.position, "jump"):
				_jump_requested = true
			elif _inside_button(event.position, "fire"):
				_fire_requested = true
			elif _inside_button(event.position, "reload"):
				_reload_requested = true
			elif _inside_button(event.position, "sprint"):
				_sprint_touch = event.index
				_sprint = true
			elif _inside_button(event.position, "crouch"):
				_crouch_touch = event.index
				_crouch = true
			elif event.position.x < _viewport_size.x * 0.48 and _move_touch == -1:
				_move_touch = event.index
				_update_move(event.position)
			elif event.position.x >= _viewport_size.x * 0.48 and _look_touch == -1:
				_look_touch = event.index
		else:
			if event.index == _move_touch:
				_move_touch = -1
				_move_vector = Vector2.ZERO
			elif event.index == _look_touch:
				_look_touch = -1
			elif event.index == _sprint_touch:
				_sprint_touch = -1
				_sprint = false
			elif event.index == _crouch_touch:
				_crouch_touch = -1
				_crouch = false
			queue_redraw()
	elif event is InputEventScreenDrag:
		if event.index == _move_touch:
			_update_move(event.position)
		elif event.index == _look_touch:
			_look_delta += event.relative
		queue_redraw()

func _update_move(position: Vector2) -> void:
	var offset := position - _joystick_center
	_move_vector = (offset / _joystick_radius).limit_length(1.0)
	queue_redraw()

func _inside_button(position: Vector2, which: String) -> bool:
	var w := _viewport_size.x
	var h := _viewport_size.y
	match which:
		"jump":
			return position.distance_to(Vector2(w - 92.0, h - 250.0)) < 58.0
		"fire":
			return position.distance_to(Vector2(w - 92.0, h - 380.0)) < 52.0
		"reload":
			return position.distance_to(Vector2(w - 215.0, h - 250.0)) < 48.0
		"sprint":
			return position.distance_to(Vector2(w - 215.0, h - 125.0)) < 52.0
		"crouch":
			return position.distance_to(Vector2(w - 92.0, h - 125.0)) < 52.0
	return false

func get_move_vector() -> Vector2:
	return _move_vector

func consume_look_delta() -> Vector2:
	var result := _look_delta
	_look_delta = Vector2.ZERO
	return result

func consume_jump() -> bool:
	var result := _jump_requested
	_jump_requested = false
	return result

func consume_fire() -> bool:
	var result := _fire_requested
	_fire_requested = false
	return result

func consume_reload() -> bool:
	var result := _reload_requested
	_reload_requested = false
	return result

func is_sprinting() -> bool:
	return _sprint

func is_crouching() -> bool:
	return _crouch

func _draw() -> void:
	if not OS.has_feature("mobile") and not OS.has_feature("android") and not OS.has_feature("ios"):
		return
	var knob := _joystick_center + _move_vector * _joystick_radius
	draw_circle(_joystick_center, _joystick_radius, Color(0.1, 0.14, 0.2, 0.28))
	draw_arc(_joystick_center, _joystick_radius, 0.0, TAU, 48, Color(0.8, 0.86, 0.95, 0.55), 3.0)
	draw_circle(knob, 36.0, Color(0.75, 0.82, 0.92, 0.52))
	_draw_button(Vector2(_viewport_size.x - 92.0, _viewport_size.y - 380.0), "FIRE", Color(0.9, 0.25, 0.2, 0.62))
	_draw_button(Vector2(_viewport_size.x - 92.0, _viewport_size.y - 250.0), "JUMP", Color(0.2, 0.65, 0.95, 0.55))
	_draw_button(Vector2(_viewport_size.x - 215.0, _viewport_size.y - 250.0), "RELOAD", Color(0.65, 0.65, 0.75, 0.58))
	_draw_button(Vector2(_viewport_size.x - 215.0, _viewport_size.y - 125.0), "RUN", Color(0.2, 0.8, 0.45, 0.55))
	_draw_button(Vector2(_viewport_size.x - 92.0, _viewport_size.y - 125.0), "CROUCH", Color(0.85, 0.65, 0.2, 0.55))

func _draw_button(center: Vector2, label: String, tint: Color) -> void:
	draw_circle(center, 48.0, tint)
	draw_arc(center, 48.0, 0.0, TAU, 40, Color(1, 1, 1, 0.75), 2.0)
	draw_string(ThemeDB.fallback_font, center + Vector2(-24.0, 5.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color.WHITE)
