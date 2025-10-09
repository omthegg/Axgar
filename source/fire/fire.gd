@tool
extends Node3D

@export_tool_button("Apply") var apply_action:Callable = apply
@export var rect:Rect2 = Rect2(0.0, 0.0, 5.0, 5.0)
@export var amount:int = 100

@onready var multimesh_instance:MultiMeshInstance3D = $MultiMeshInstance3D

func _ready() -> void:
	apply()


func apply() -> void:
	var min_x:float = rect.position.x
	var min_z:float = rect.position.y
	var max_x:float = min_x + rect.size.x
	var max_z:float = min_z + rect.size.y
	
	multimesh_instance.multimesh.instance_count = amount
	
	for i in multimesh_instance.multimesh.instance_count:
		var b:Basis = Basis()
		var o:Vector3 = Vector3(randf_range(min_x, max_x), global_position.y, randf_range(min_z, max_z))
		var t:Transform3D = Transform3D(b, o)
		multimesh_instance.multimesh.set_instance_transform(i, t)
