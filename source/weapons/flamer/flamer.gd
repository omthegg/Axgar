extends Weapon

@export var character_camera:Camera3D
@export var character_head:Node3D
@export var character_arms:Node3D
@export var nozzle_vm:Node3D
@export var nozzle_m:Node3D

func _on_just_fired() -> void:
	var pos:Vector3 = character_head.global_position - character_head.global_basis.z
	var vel:Vector3 = (-character_head.global_basis.z) * 0.2
	Global.scene_manager.flame_manager.create_flame(pos, vel, get_parent())
