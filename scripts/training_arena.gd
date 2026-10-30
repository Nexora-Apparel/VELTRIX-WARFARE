extends Node3D
class_name VeltrixTrainingArena

## Runtime-built low-poly training range cover and perimeter.
## All cover is static and uses matching collision geometry.

@export var cover_material_color := Color(0.24, 0.28, 0.31, 1.0)

func _ready() -> void:
	_build_perimeter()
	_build_cover()

func _build_perimeter() -> void:
	_add_box("NorthBoundary", Vector3(0, 1.0, -14.7), Vector3(29.4, 2.0, 0.5), true)
	_add_box("SouthBoundary", Vector3(0, 1.0, 14.7), Vector3(29.4, 2.0, 0.5), true)
	_add_box("WestBoundary", Vector3(-14.7, 1.0, 0), Vector3(0.5, 2.0, 29.4), true)
	_add_box("EastBoundary", Vector3(14.7, 1.0, 0), Vector3(0.5, 2.0, 29.4), true)

func _build_cover() -> void:
	# Low chest-high barriers: players can shoot over them while crouched behind cover.
	_add_box("CoverWest", Vector3(-7.0, 0.65, -7.0), Vector3(3.8, 1.3, 0.55), true)
	_add_box("CoverEast", Vector3(7.0, 0.65, -7.0), Vector3(3.8, 1.3, 0.55), true)
	_add_box("CoverCenterLeft", Vector3(-3.8, 0.65, 1.0), Vector3(0.55, 1.3, 3.0), true)
	_add_box("CoverCenterRight", Vector3(3.8, 0.65, 1.0), Vector3(0.55, 1.3, 3.0), true)
	# Waist-high crate stacks near the side lanes.
	_add_box("CrateWest", Vector3(-10.0, 0.55, 2.5), Vector3(1.5, 1.1, 1.5), true)
	_add_box("CrateEast", Vector3(10.0, 0.55, -2.0), Vector3(1.5, 1.1, 1.5), true)
	_add_box("CrateRearLeft", Vector3(-8.5, 0.55, -11.0), Vector3(1.4, 1.1, 1.4), true)
	_add_box("CrateRearRight", Vector3(8.5, 0.55, -11.0), Vector3(1.4, 1.1, 1.4), true)

func _add_box(node_name: String, location: Vector3, dimensions: Vector3, collidable: bool) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = location
	add_child(body)

	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = dimensions
	mesh_instance.mesh = box_mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = cover_material_color
	material.roughness = 0.92
	mesh_instance.material_override = material
	body.add_child(mesh_instance)

	if collidable:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = dimensions
		collision.shape = shape
		body.add_child(collision)
