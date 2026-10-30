extends CharacterBody3D
class_name VeltrixTrainingBot

## Training opponent with obstacle-aware steering and line-of-sight ranged attacks.

@export var maximum_health: float = 100.0
@export var move_speed: float = 2.2
@export var attack_range: float = 1.65
@export var attack_damage: float = 8.0
@export var attack_interval: float = 1.25
@export var detection_range: float = 24.0
@export var ranged_minimum_range: float = 3.5
@export var ranged_maximum_range: float = 13.0
@export var ranged_damage: float = 5.0
@export var ranged_interval: float = 1.6
@export var obstacle_probe_distance: float = 2.4

var health: float
var attack_timer: float = 0.0
var ranged_timer: float = 0.0
var player: CharacterBody3D
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	health = maximum_health
	add_to_group("damageable")
	player = get_tree().get_first_node_in_group("player") as CharacterBody3D

func _physics_process(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	ranged_timer = maxf(0.0, ranged_timer - delta)
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as CharacterBody3D
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	var offset := player.global_position - global_position
	offset.y = 0.0
	var distance := offset.length()

	if distance <= detection_range:
		var direction := offset.normalized()
		if distance > attack_range:
			var movement_direction := _steer_around_obstacles(direction)
			velocity.x = movement_direction.x * move_speed
			velocity.z = movement_direction.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0.0, move_speed * 3.0)
			velocity.z = move_toward(velocity.z, 0.0, move_speed * 3.0)
			if attack_timer <= 0.0:
				_damage_player(attack_damage)
				attack_timer = attack_interval

		if distance >= ranged_minimum_range and distance <= ranged_maximum_range and ranged_timer <= 0.0:
			if _has_line_of_sight():
				_damage_player(ranged_damage)
				ranged_timer = ranged_interval

		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()

func _steer_around_obstacles(desired: Vector3) -> Vector3:
	var space := get_world_3d().direct_space_state
	var origin := global_position + Vector3.UP * 0.85
	var forward_end := origin + desired * obstacle_probe_distance
	var forward_query := PhysicsRayQueryParameters3D.create(origin, forward_end)
	forward_query.exclude = [get_rid()]
	var forward_hit := space.intersect_ray(forward_query)
	if forward_hit.is_empty():
		return desired

	var right := Vector3(desired.z, 0.0, -desired.x).normalized()
	var left_clearance := _probe_clearance(space, origin, desired.rotated(Vector3.UP, deg_to_rad(-55.0)))
	var right_clearance := _probe_clearance(space, origin, desired.rotated(Vector3.UP, deg_to_rad(55.0)))
	if left_clearance > right_clearance:
		return desired.rotated(Vector3.UP, deg_to_rad(-65.0)).normalized()
	if right_clearance > left_clearance:
		return desired.rotated(Vector3.UP, deg_to_rad(65.0)).normalized()
	return -desired.rotated(Vector3.UP, deg_to_rad(90.0)).normalized()

func _probe_clearance(space: PhysicsDirectSpaceState3D, origin: Vector3, direction: Vector3) -> float:
	var query := PhysicsRayQueryParameters3D.create(origin, origin + direction * obstacle_probe_distance)
	query.exclude = [get_rid()]
	var hit := space.intersect_ray(query)
	if hit.is_empty():
		return obstacle_probe_distance
	return origin.distance_to(hit.position)

func _has_line_of_sight() -> bool:
	if not is_instance_valid(player):
		return false
	var origin := global_position + Vector3.UP * 1.0
	var target := player.global_position + Vector3.UP * 1.0
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [get_rid()]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	return not hit.is_empty() and hit.get("collider") == player

func _damage_player(amount: float) -> void:
	if not is_instance_valid(player):
		return
	var health_node := player.get_node_or_null("PlayerHealth")
	if health_node != null and health_node.has_method("take_damage"):
		health_node.take_damage(amount)

func take_damage(amount: float) -> void:
	if amount <= 0.0:
		return
	health = maxf(0.0, health - amount)
	if health <= 0.0:
		queue_free()
