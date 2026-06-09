@tool
extends Node3D

@export_tool_button("Refresh") var refresh_button = Callable(self, "refresh")

@export var points:PackedVector3Array = []
@export var material:StandardMaterial3D

@onready var mmi:MultiMeshInstance3D = $MultiMeshInstance3D
@onready var rotation_helper:Node3D = $RotationHelper


func refresh() -> void:
	mmi.multimesh.visible_instance_count = 0
	mmi.multimesh.instance_count = 0
	mmi.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	mmi.multimesh.instance_count = points.size() - 1
	mmi.multimesh.visible_instance_count = -1
	
	for i in mmi.multimesh.instance_count:
		var t:Transform3D = Transform3D()
		var a:Vector3 = points[i]
		var b:Vector3 = points[i + 1]
		
		rotation_helper.position = a
		rotation_helper.look_at(to_global(b))
		t = t.translated((a + b) / 2.0)
		t = t.rotated_local(Vector3.UP, rotation_helper.rotation.y)
		t = t.rotated_local(Vector3.RIGHT, rotation_helper.rotation.x + deg_to_rad(90.0))
		t = t.rotated_local(Vector3.BACK, rotation_helper.rotation.z)
		t = t.scaled_local(Vector3(1.0, (b - a).length(), 1.0))
		
		mmi.multimesh.set_instance_transform(i, t)
	
	mmi.material_override = material
