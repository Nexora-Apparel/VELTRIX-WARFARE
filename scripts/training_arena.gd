extends Node3D
class_name VeltrixTrainingArena

## Runtime-built training range with a dedicated low jump-test hurdle.

@export var cover_material_color := Color(0.24, 0.28, 0.31, 1.0)

func _ready() -> void:
	_build_perimeter()
	_build_cover()
	_build_jump_hurdle()

func _build_perimeter() -> void:
	_add_box("NorthBoundary", Vector3(0, 1.0, -14.7), Vector3(29.4, 2.0, 0.5))
	_add_box("SouthBoundary", Vector3(0, 1.0, 14.7), Vector3(29.4, 2.0, 0.5))
	_add_box("WestBoundary", Vector3(-14.7, 1.0, 0), Vector3(0.5, 2.0, 29.4))
	_add_box("EastBoundary", Vector3(14.7, 1.0, 0), Vector3(0.5, 2.0, 29.4))

func _build_cover() -> void:
	_add_box("CoverWest", Vector3(-7.0, 0.65, -7.0), Vector3(3.8, 1.3, 0.55))
	_add_box("CoverEast", Vector3(7.0, 0.65, -7.0), Vector3(3.8, 1.3, 0.55))
	_add_box("CoverCenterLeft", Vector3(-3.8, 0.65, 1.0), Vector3(0.55, 1.3, 3.0))
	_add_box("CoverCenterRight", Vector3(3.8, 0.65, 1.0), Vector3(0.55, 1.3, 3.0))
	_add_box("CrateWest", Vector3(-10.0, 0.55, 2.5), Vector3(1.5, 1.1, 1.5))
	_add_box("CrateEast", Vector3(10.0, 0.55, -2.0), Vector3(1.5, 1.1, 1.5))
	_add_box("CrateRearLeft", Vector3(-8.5, 0.55, -11.0), Vector3(1.4, 1.1, 1.4))
	_add_box("CrateRearRight", Vector3(8.5, 0.55, -11.0), Vector3(1.4, 1.1, 1.4))

func _build_jump_hurdle() -> void:
	# 0.62 m obstacle placed directly ahead of the spawn point.
	_add_box("JumpTestHurdle", Vector3(0, 0.31, 0.2), Vector3(2.2, 0.62, 0.42), Color(0.34, 0.29, 0.19, 1.0))

func _add_box(node_name: String, location: Vector3, dimensions: Vector3, color: Color = cover_material_color) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = location
	add_child(body)
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = dimensions
	mesh_instance.mesh = box_mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.92
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
