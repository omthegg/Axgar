extends Weapon

@export var character_camera:Camera3D
@export var character_head:Node3D
@export var character_arms:Node3D
@export var nozzle_vm:Node3D
@export var nozzle_m:Node3D

@onready var flame_manager:Node3D = $FlameManager

var previous_head_basis_z:Vector3

#func _physics_process(delta: float) -> void:
	#super(delta)
	#
	#var a:float = character_head.global_basis.z.angle_to(previous_head_basis_z)
	#
	#cooldown_time = 0.05 - a
	#if cooldown_time < 0.01:
		#cooldown_time = 0.01
	#
	#print(a)
	#
	#previous_head_basis_z = character_head.global_basis.z


func _on_just_fired() -> void:
	var pos:Vector3 = character_head.global_position - character_head.global_basis.z
	var vel:Vector3 = (-character_head.global_basis.z) * 0.3
	flame_manager.create_flame(pos, vel, get_parent())
