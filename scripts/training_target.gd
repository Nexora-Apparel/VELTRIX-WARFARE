extends StaticBody3D
class_name VeltrixTrainingTarget

@export var max_health: float = 100.0
var health: float

func _ready() -> void:
	health = max_health
	add_to_group("damageable")

func take_damage(amount: float) -> void:
	health = maxf(0.0, health - amount)
	if health <= 0.0:
		queue_free()
