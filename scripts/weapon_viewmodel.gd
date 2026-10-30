extends Node3D
class_name VeltrixWeaponViewModel

## Original compact service-pistol viewmodel with two supporting gloved hands.

var _time := 0.0
var _base_position := Vector3.ZERO

func _ready() -> void:
	_base_position = position
	_build_pistol()

func _process(delta: float) -> void:
	_time += delta
	position = _base_position + Vector3(0.0, sin(_time * 2.2) * 0.0025, 0.0)

func _material(color: Color, metallic: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.metallic = metallic
	m.roughness = 0.68
	return m

func _box(label: String, pos: Vector3, size: Vector3, material: Material) -> void:
	var node := MeshInstance3D.new()
	node.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.position = pos
	node.material_override = material
	add_child(node)

func _capsule(label: String, pos: Vector3, radius: float, height: float, material: Material) -> void:
	var node := MeshInstance3D.new()
	node.name = label
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	node.mesh = mesh
	node.position = pos
	node.material_override = material
	add_child(node)

func _build_pistol() -> void:
	var slide := _material(Color(0.105, 0.12, 0.13), 0.72)
	var frame := _material(Color(0.055, 0.065, 0.07))
	var metal := _material(Color(0.27, 0.29, 0.29), 0.82)
	var glove := _material(Color(0.09, 0.12, 0.105))
	var cuff := _material(Color(0.17, 0.20, 0.16))
	# Pistol points along camera forward (-Z), centered in the lower-right view.
	_box("PistolSlide", Vector3(0.22, -0.235, -0.66), Vector3(0.13, 0.115, 0.34), slide)
	_box("PistolFrame", Vector3(0.22, -0.295, -0.65), Vector3(0.12, 0.07, 0.28), frame)
	_box("PistolBarrel", Vector3(0.22, -0.225, -0.84), Vector3(0.055, 0.055, 0.12), metal)
	_box("PistolMuzzle", Vector3(0.22, -0.225, -0.91), Vector3(0.075, 0.07, 0.025), frame)
	_box("PistolGrip", Vector3(0.22, -0.405, -0.57), Vector3(0.105, 0.22, 0.12), frame)
	_box("PistolMagazineBase", Vector3(0.22, -0.515, -0.57), Vector3(0.09, 0.025, 0.105), metal)
	_box("FrontSight", Vector3(0.22, -0.169, -0.80), Vector3(0.025, 0.025, 0.035), metal)
	_box("RearSight", Vector3(0.22, -0.169, -0.52), Vector3(0.07, 0.025, 0.035), metal)
	# Forearms enter frame from both lower corners; hands meet around the grip.
	_capsule("RightForearm", Vector3(0.39, -0.43, -0.31), 0.075, 0.48, cuff)
	_capsule("LeftForearm", Vector3(-0.31, -0.47, -0.37), 0.07, 0.42, cuff)
	_capsule("RightGlove", Vector3(0.245, -0.36, -0.55), 0.075, 0.19, glove)
	_capsule("LeftSupportGlove", Vector3(0.115, -0.38, -0.70), 0.065, 0.17, glove)
