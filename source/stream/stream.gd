extends Node3D

@export var point_count:int = 5
@export var starting_velocity:Vector3 = Vector3(0.0, 3.0, -2.0)
@export var gravity:Vector3 = Vector3(0.0, -1.0, 0.0)

@onready var joint_multimesh_instance:MultiMeshInstance3D = $JointMultiMeshInstance3D

var points:PackedVector3Array = []

func _ready() -> void:
	points.resize(point_count)
	joint_multimesh_instance.multimesh.instance_count = point_count


func _process(_delta: float) -> void:
	points.resize(0)
	points.resize(point_count)
	
	for p in points.size():
		if p != 0:
			points[p] = points[p - 1]
			
			points[p] += starting_velocity
			
			points[p] += gravity * p
		
		var t:Transform3D = Transform3D()
		t = t.translated(points[p])
		joint_multimesh_instance.multimesh.set_instance_transform(p, t)
