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


func _input(event: InputEvent) -> void:
	if event.is_action("jump"):
		mesh_instance.material_override.set_shader_parameter("current_shatter_frame", 0)
		var tween:Tween = create_tween()
		tween.tween_property(mesh_instance, 
		"material_override:shader_parameter/current_shatter_frame",
		 43, 1.0)
