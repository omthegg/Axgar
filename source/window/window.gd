@tool
extends Node3D

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D

@export var size:Vector2 = Vector2(1.0, 1.0):
	set(value):
		size = value
		if !mesh_instance:
			return
		
		mesh_instance.mesh.size = size

func _ready() -> void:
	mesh_instance.mesh.size = size
