extends Node3D

var camera:Camera3D

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	camera = get_tree().root.get_camera_3d()
	global_position = camera.global_position
