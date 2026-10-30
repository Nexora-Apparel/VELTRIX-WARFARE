extends CharacterBody3D
class_name VeltrixPlayerController

## Desktop and Android first-person controller.
## Android uses a left virtual joystick and right-side touch-look surface.

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 7.4
@export var crouch_speed: float = 2.8
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var touch_sensitivity: float = 0.004
@export var look_limit_degrees: float = 85.0
@export var standing_camera_height: float = 1.55
@export var crouching_camera_height: float = 1.05

@onready var camera_pivot: Node3D = $CameraPivot
@onready var mobile_controls: VeltrixMobileControls = get_node_or_null("../MobileControls/TouchControls")

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	if not OS.has_feature("mobile") and not OS.has_feature("android") and not OS.has_feature("ios"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_apply_look(event.relative, mouse_sensitivity)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _apply_look(relative: Vector2, sensitivity: float) -> void:
	rotate_y(-relative.x * sensitivity)
	camera_pivot.rotate_x(-relative.y * sensitivity)
	camera_pivot.rotation.x = clampf(
		camera_pivot.rotation.x,
		deg_to_rad(-look_limit_degrees),
		deg_to_rad(look_limit_degrees)
	)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var mobile_move := Vector2.ZERO
	var mobile_sprint := false
	var mobile_crouch := false
	var mobile_jump := false
	if mobile_controls != null:
		mobile_move = mobile_controls.get_move_vector()
		_apply_look(mobile_controls.consume_look_delta(), touch_sensitivity)
		mobile_sprint = mobile_controls.is_sprinting()
		mobile_crouch = mobile_controls.is_crouching()
		mobile_jump = mobile_controls.consume_jump()

	if (Input.is_action_just_pressed("jump") or mobile_jump) and is_on_floor():
		velocity.y = jump_velocity

	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if mobile_move.length() > 0.08:
		input_vector = mobile_move
	var direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()

	var crouching := mobile_crouch or Input.is_key_pressed(KEY_CTRL)
	var sprinting := (mobile_sprint or Input.is_key_pressed(KEY_SHIFT)) and not crouching
	var active_speed := crouch_speed if crouching else (sprint_speed if sprinting else walk_speed)
	camera_pivot.position.y = move_toward(
		camera_pivot.position.y,
		crouching_camera_height if crouching else standing_camera_height,
		delta * 3.5
	)

	if direction:
		velocity.x = direction.x * active_speed
		velocity.z = direction.z * active_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, active_speed)
		velocity.z = move_toward(velocity.z, 0.0, active_speed)

	move_and_slide()
