@tool
extends Node3D

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D
@onready var camera:Camera3D = $SubViewport/Camera3D
@onready var subviewport:SubViewport = $SubViewport

@export var size:Vector2 = Vector2.ONE:
	set(value):
		size = value
		if !mesh_instance:
			return
		
		mesh_instance.mesh.size = size
		subviewport.size = size * Vector2(512, 512)


func _ready() -> void:
	mesh_instance.mesh.size = size
	subviewport.size = size * Vector2(512, 512)


func _process(_delta: float) -> void:
	camera.global_transform = global_transform
#	var main_cam:Camera3D = get_tree().root.get_camera_3d()
#	if main_cam:
#		#camera.global_transform = (global_transform.affine_inverse() * main_cam.global_transform)
#		var relative_transform:Transform3D = global_transform.affine_inverse() * main_cam.global_transform
#		relative_transform = relative_transform.scaled(Vector3(-1.0, 1.0, 1.0))
#		camera.global_transform = global_transform * relative_transform
#	
#	$Ball.global_transform = camera.global_transform

#var main_cam:Camera3D = Global.player_camera
#	if other_portal and main_cam:
#		other_portal.camera.global_transform = other_portal.global_transform * global_transform.affine_inverse() * main_cam.global_transform

#func _physics_process(_delta: float) -> void:
#	camera.position = position
#	camera.rotation = rotation
