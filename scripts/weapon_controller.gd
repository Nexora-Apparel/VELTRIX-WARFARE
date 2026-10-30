extends Node
class_name VeltrixWeaponController

## Prototype hitscan rifle: 30-round magazine, 90 reserve, 650 RPM.

@export var damage: float = 25.0
@export var range_meters: float = 120.0
@export var rounds_per_minute: float = 650.0
@export var magazine_capacity: int = 30
@export var starting_reserve: int = 90

@onready var camera: Camera3D = get_parent()

var magazine_ammo: int
var reserve_ammo: int
var fire_cooldown: float = 0.0
var hud_label: Label
var player_body: CollisionObject3D
var mobile_controls: VeltrixMobileControls

func _ready() -> void:
	magazine_ammo = magazine_capacity
	reserve_ammo = starting_reserve
	player_body = camera.get_parent().get_parent() as CollisionObject3D
	mobile_controls = player_body.get_node_or_null("../MobileControls/TouchControls")
	_create_hud()
	_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		fire_weapon()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_R:
		reload_weapon()

func _process(delta: float) -> void:
	fire_cooldown = maxf(0.0, fire_cooldown - delta)
	if mobile_controls != null and mobile_controls.consume_fire():
		fire_weapon()

func fire_weapon() -> void:
	if fire_cooldown > 0.0 or magazine_ammo <= 0:
		return
	magazine_ammo -= 1
	fire_cooldown = 60.0 / rounds_per_minute
	var origin := camera.global_position
	var destination := origin + (-camera.global_transform.basis.z * range_meters)
	var query := PhysicsRayQueryParameters3D.create(origin, destination)
	query.exclude = [player_body.get_rid()]
	var hit := camera.get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		var target: Object = hit.get("collider")
		if target != null and target.has_method("take_damage"):
			target.take_damage(damage)
	_update_hud()

func reload_weapon() -> void:
	if magazine_ammo >= magazine_capacity or reserve_ammo <= 0:
		return
	var needed := magazine_capacity - magazine_ammo
	var loaded := mini(needed, reserve_ammo)
	magazine_ammo += loaded
	reserve_ammo -= loaded
	_update_hud()

func _create_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "WeaponHUD"
	layer.layer = 20
	get_tree().current_scene.add_child(layer)

	hud_label = Label.new()
	hud_label.name = "AmmoCounter"
	hud_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	hud_label.position = Vector2(-210.0, -86.0)
	hud_label.size = Vector2(180.0, 48.0)
	hud_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hud_label.add_theme_font_size_override("font_size", 24)
	layer.add_child(hud_label)

	var crosshair := Label.new()
	crosshair.text = "+"
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-8.0, -20.0)
	crosshair.add_theme_font_size_override("font_size", 30)
	layer.add_child(crosshair)

func _update_hud() -> void:
	if is_instance_valid(hud_label):
		hud_label.text = "%02d  |  %02d" % [magazine_ammo, reserve_ammo]
