extends Node
class_name VeltrixPlayerHealth

## Player health component. Enemy systems can call take_damage(amount).

@export var maximum_health: float = 100.0
var current_health: float
var health_label: Label
var is_dead: bool = false

func _ready() -> void:
	current_health = maximum_health
	_create_health_hud()
	_update_health_hud()

func take_damage(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	current_health = maxf(0.0, current_health - amount)
	_update_health_hud()
	if current_health <= 0.0:
		is_dead = true
		health_label.text = "ELIMINATED"
		get_parent().set_physics_process(false)

func restore_health(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	current_health = minf(maximum_health, current_health + amount)
	_update_health_hud()

func _create_health_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "PlayerHealthHUD"
	layer.layer = 19
	get_tree().current_scene.add_child(layer)
	health_label = Label.new()
	health_label.name = "HealthValue"
	health_label.position = Vector2(28.0, 24.0)
	health_label.size = Vector2(220.0, 44.0)
	health_label.add_theme_font_size_override("font_size", 25)
	layer.add_child(health_label)

func _update_health_hud() -> void:
	if is_instance_valid(health_label):
		health_label.text = "HEALTH  %03d" % int(ceil(current_health))
