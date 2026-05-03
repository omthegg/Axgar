extends Node3D

# mmi = MultiMeshInstance
@onready var snow_mmi:MultiMeshInstance3D = $SnowMultiMeshInstance3D

@export var snow:bool = false

var camera:Camera3D

func _ready() -> void:
	#snow_mmi.multimesh.instance_count = 16
	#var i:int = 0
	#for x in range(-2, 2):
	#	for z in range(-2, 2):
	#		var t:Transform3D = Transform3D(Basis(), Vector3(x, 0.0, z))
	#		snow_mmi.multimesh.set_instance_transform(i, t)
	#		i += 1
	
	$SnowParticles.visible = snow
	$RainParticles.visible = !snow


func _physics_process(_delta: float) -> void:
	camera = get_tree().root.get_camera_3d()
	global_position = camera.global_position
