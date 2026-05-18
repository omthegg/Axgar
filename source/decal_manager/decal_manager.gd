extends Node3D

@onready var bullet_holes:MultiMeshInstance3D = $BulletHoles
@onready var helper:Node3D = $Helper

var bullet_hole_number = 0


func add_bullet_hole(pos:Vector3, normal:Vector3) -> void:
	#if bullet_holes.multimesh.visible_instance_count < bullet_holes.multimesh.instance_count:
	#	bullet_holes.multimesh.visible_instance_count += 1
	
	helper.global_position = pos + normal/20.0
	helper.look_at(helper.global_position + normal)
	bullet_holes.multimesh.set_instance_transform(bullet_hole_number,
	helper.global_transform)
	
	bullet_hole_number += 1
	if bullet_hole_number > (bullet_holes.multimesh.instance_count - 1):
		bullet_hole_number = 0
