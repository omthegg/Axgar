extends Weapon

@export var character_camera:Camera3D
@export var character_head:Node3D
@export var character_arms:Node3D
@export var nozzle_vm:Node3D
@export var nozzle_m:Node3D
@export var raycast:RayCast3D

@onready var flame_manager:Node3D = $FlameManager
@onready var velocity_helper:Node3D = $VelocityHelper


func _on_just_fired() -> void:
	var pos:Vector3 = nozzle_vm.global_position#character_head.global_position - character_head.global_basis.z
	var vel:Vector3
	
	#if raycast.is_colliding():
	#	velocity_helper.look_at(raycast.get_collision_point())
	#	vel = (-velocity_helper.global_basis.z) * 0.3
	#else:
	vel = (-character_head.global_basis.z) * 0.3
	
	flame_manager.create_flame(pos, vel, get_parent())
