extends Node3D

var head:Node3D
var character_controller:CharacterControllerComponent

var max_tilt_angle:float = 0.3
var target_tilt_angle:float = 0.0

func _physics_process(delta:float) -> void:
	head_tilt(delta)


func head_tilt(delta:float) -> void:
	#if head.rotation_degrees.x < 80 and head.rotation_degrees.x > -80:
	if character_controller.input_dir.x == 0:
		target_tilt_angle = 0.0
	elif character_controller.input_dir.x > 0:
		target_tilt_angle = -max_tilt_angle
	elif character_controller.input_dir.x < 0:
		target_tilt_angle = max_tilt_angle
	
	head.rotation_degrees.z = lerp_angle(head.rotation_degrees.z, target_tilt_angle, 15.0*delta)
	#else:
	#	target_tilt_angle = 0.0
	#	head.rotation_degrees.z = 0.0
