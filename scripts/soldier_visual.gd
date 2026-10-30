extends Node3D
class_name VeltrixSoldierVisual

## Procedural first playable character: modern infantry silhouette and equipment.
## Geometry is deliberately lightweight and uses original, unbranded design.

func _ready() -> void:
	_build_soldier()

func _mat(color: Color, roughness: float = 0.88, metallic: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = metallic
	return m

func _box(label: String, pos: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.position = pos
	node.material_override = material
	add_child(node)
	return node

func _sphere(label: String, pos: Vector3, radius: float, height: float, material: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = label
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = height
	node.mesh = mesh
	node.position = pos
	node.material_override = material
	add_child(node)
	return node

func _build_soldier() -> void:
	var fabric := _mat(Color(0.16, 0.20, 0.16))
	var dark_fabric := _mat(Color(0.075, 0.095, 0.085))
	var armor := _mat(Color(0.105, 0.135, 0.12), 0.72)
	var trim := _mat(Color(0.29, 0.31, 0.23))
	var skin := _mat(Color(0.36, 0.25, 0.18))
	var helmet := _mat(Color(0.12, 0.16, 0.13), 0.62)
	# Helmet, face and neck.
	_sphere("Head", Vector3(0, 0.39, 0), 0.17, 0.36, skin)
	_sphere("CombatHelmet", Vector3(0, 0.51, 0.015), 0.205, 0.23, helmet)
	_box("HelmetFrontRim", Vector3(0, 0.47, -0.17), Vector3(0.25, 0.035, 0.055), trim)
	_box("Neck", Vector3(0, 0.20, 0), Vector3(0.16, 0.16, 0.15), dark_fabric)
	# Plate carrier and shoulder armor.
	_box("PlateCarrier", Vector3(0, -0.18, -0.015), Vector3(0.57, 0.56, 0.25), armor)
	_box("FrontPlate", Vector3(0, -0.16, -0.151), Vector3(0.39, 0.34, 0.035), dark_fabric)
	for i in range(3):
		_box("MagazinePouch%d" % i, Vector3(-0.17 + i * 0.17, -0.34, -0.18), Vector3(0.12, 0.16, 0.075), trim)
	_box("RadioPack", Vector3(0, -0.13, 0.17), Vector3(0.32, 0.38, 0.18), dark_fabric)
	# Shoulder caps and upper arms.
	_sphere("LeftShoulderArmor", Vector3(-0.34, 0.02, 0), 0.15, 0.22, armor)
	_sphere("RightShoulderArmor", Vector3(0.34, 0.02, 0), 0.15, 0.22, armor)
	_box("LeftSleeve", Vector3(-0.37, -0.18, 0), Vector3(0.18, 0.36, 0.18), fabric)
	_box("RightSleeve", Vector3(0.37, -0.18, 0), Vector3(0.18, 0.36, 0.18), fabric)
	_sphere("LeftGlove", Vector3(-0.37, -0.39, -0.035), 0.095, 0.16, dark_fabric)
	_sphere("RightGlove", Vector3(0.37, -0.39, -0.035), 0.095, 0.16, dark_fabric)
	# Belt and utility equipment.
	_box("DutyBelt", Vector3(0, -0.49, 0), Vector3(0.55, 0.09, 0.28), dark_fabric)
	_box("LeftHipPouch", Vector3(-0.29, -0.48, 0), Vector3(0.13, 0.19, 0.16), trim)
	_box("RightHipPouch", Vector3(0.29, -0.48, 0), Vector3(0.13, 0.19, 0.16), trim)
