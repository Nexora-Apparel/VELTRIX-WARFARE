extends CharacterBody3D
class_name VeltrixPlayerController

## Initial desktop-test controller. Mobile touch controls are a separate next milestone.

@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var look_limit_degrees: float = 85.0

@onready var camera_pivot: Node3D = $CameraPivot

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	if not OS.has_feature("android"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(
			camera_pivot.rotation.x,
			deg_to_rad(-look_limit_degrees),
			deg_to_rad(look_limit_degrees)
		)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()
