@tool
extends Node3D

@export var size = Vector2(1.0, 1.0):
	set(value):
		size = value
		$MeshInstance3D.mesh.size = size
		$MeshInstance3D.material_override.set_shader_parameter("size", size)
