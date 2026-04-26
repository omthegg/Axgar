extends Node3D

@export var snow:bool = false

var camera:Camera3D

func _ready() -> void:
	$SnowParticles.visible = snow
	$RainParticles.visible = !snow


func _physics_process(_delta: float) -> void:
	camera = get_tree().root.get_camera_3d()
	global_position = camera.global_position
