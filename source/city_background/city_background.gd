@tool
extends Node3D

@export_tool_button("Apply") var apply_action:Callable = apply

@export var rect:Rect2 = Rect2(Vector2(0, 0), Vector2(100, 100))
@export var building_count:int = 5
@export var max_dimensions:Vector3 = Vector3(15, 30, 15)
@export var min_dimensions:Vector3 = Vector3(5, 10, 5)
@export var generation_seed:int = 0

@onready var mmi:MultiMeshInstance3D = $MultiMeshInstance3D

func _ready() -> void:
	apply()


func apply() -> void:
	mmi.multimesh.visible_instance_count = 0
	mmi.multimesh.instance_count = building_count
	mmi.multimesh.visible_instance_count = -1
	
	seed(generation_seed)
	
	for i in building_count:
		var x:float = randf_range(rect.position.x, rect.size.x)
		var z:float = randf_range(rect.position.y, rect.size.y)
		
		var w:float = randf_range(min_dimensions.x, max_dimensions.x)
		var h:float = randf_range(min_dimensions.y, max_dimensions.y)
		var l:float = randf_range(min_dimensions.z, max_dimensions.z)
		
		var y:float = h/2.0
		
		var t:Transform3D = Transform3D()
		t = t.translated(Vector3(x, y, z))
		t = t.scaled_local(Vector3(w, h, l))
		
		mmi.multimesh.set_instance_transform(i, t)
