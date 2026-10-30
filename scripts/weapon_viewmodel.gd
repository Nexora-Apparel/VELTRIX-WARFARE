extends Node3D
class_name VeltrixWeaponViewModel

## Original low-poly first-person rifle and gloved forearms.
## Procedural primitives keep the prototype self-contained and lightweight.

var _time: float = 0.0
var _base_position := Vector3(0.0, 0.0, 0.0)

func _ready() -> void:
	_base_position = position
	_build_viewmodel()

func _process(delta: float) -> void:
	_time += delta
	position = _base_position + Vector3(0.0, sin(_time * 2.2) * 0.003, 0.0)

func _build_viewmodel() -> void:
	var rifle := _material(Color(0.12, 0.15, 0.17))
	var metal := _material(Color(0.24, 0.27, 0.29))
	var glove := _material(Color(0.10, 0.13, 0.12))
	var accent := _material(Color(0.32, 0.35, 0.28))

	_add_box("Receiver", Vector3(0.02, -0.22, -0.61), Vector3(0.19, 0.17, 0.55), rifle)
	_add_box("Handguard", Vector3(0.02, -0.20, -0.91), Vector3(0.16, 0.14, 0.34), accent)
	_add_box("Barrel", Vector3(0.02, -0.19, -1.16), Vector3(0.055, 0.055, 0.34), metal)
	_add_box("Stock", Vector3(0.02, -0.23, -0.27), Vector3(0.15, 0.13, 0.25), rifle)
	_add_box("Magazine", Vector3(0.02, -0.37, -0.62), Vector3(0.11, 0.22, 0.15), metal)
	_add_box("Grip", Vector3(0.10, -0.37, -0.46), Vector3(0.09, 0.20, 0.10), rifle)
	_add_box("Sight", Vector3(0.02, -0.11, -0.70), Vector3(0.07, 0.055, 0.12), metal)

	_add_forearm("LeftForearm", Vector3(-0.22, -0.34, -0.43), Vector3(-0.19, -0.27, -0.76), glove)
	_add_forearm("RightForearm", Vector3(0.28, -0.37, -0.30), Vector3(0.13, -0.27, -0.59), glove)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.25
	material.roughness = 0.72
	return material

func _add_box(node_name: String, local_position: Vector3, dimensions: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position = local_position
	add_child(mesh_instance)

func _add_forearm(node_name: String, start: Vector3, finish: Vector3, material: Material) -> void:
	var arm := MeshInstance3D.new()
	arm.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.085
	mesh.height = 0.52
	arm.mesh = mesh
	arm.material_override = material
	arm.position = (start + finish) * 0.5
	arm.look_at(arm.position + (finish - start).normalized(), Vector3.UP)
	arm.rotate_object_local(Vector3.RIGHT, deg_to_rad(90.0))
	add_child(arm)
