extends CharacterBody3D
class_name VeltrixTrainingBot

## Simple close-range training opponent. Uses direct pursuit in the open training yard.

@export var maximum_health: float = 100.0
@export var move_speed: float = 2.2
@export var attack_range: float = 1.65
@export var attack_damage: float = 8.0
@export var attack_interval: float = 1.25
@export var detection_range: float = 24.0

var health: float
var attack_timer: float = 0.0
var player: CharacterBody3D
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	health = maximum_health
	add_to_group("damageable")
	player = get_tree().get_first_node_in_group("player") as CharacterBody3D

func _physics_process(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as CharacterBody3D
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	var offset := player.global_position - global_position
	offset.y = 0.0
	var distance := offset.length()
	if distance <= detection_range and distance > attack_range:
		var direction := offset.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	elif distance <= attack_range:
		velocity.x = move_toward(velocity.x, 0.0, move_speed * 3.0)
		velocity.z = move_toward(velocity.z, 0.0, move_speed * 3.0)
		if attack_timer <= 0.0:
			var health_node := player.get_node_or_null("PlayerHealth")
			if health_node != null and health_node.has_method("take_damage"):
				health_node.take_damage(attack_damage)
			attack_timer = attack_interval
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)
	move_and_slide()

func take_damage(amount: float) -> void:
	if amount <= 0.0:
		return
	health = maxf(0.0, health - amount)
	if health <= 0.0:
		queue_free()
