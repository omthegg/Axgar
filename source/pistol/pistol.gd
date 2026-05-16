extends Node3D

## The AnimationTree for the 3rd-person model.
@export var m_animation_tree:AnimationTree

## The name of the shooting oneshot in the AnimationTree of the
## 3rd-person model.
@export var m_shoot_oneshot_name:StringName

## The AnimationPlayer for the 1st-person/view model.
@export var vm_animation_player:AnimationPlayer

## The name of the shooting animation in the AnimationPlayer of the
## 1st-person/view model.
@export var vm_shoot_animation_name:StringName

## The RayCast3D from which the pistol will shoot.
@export var raycast:RayCast3D


func shoot() -> void:
	if !m_animation_tree:
		return
	
	if !m_shoot_oneshot_name:
		return
	
	if !vm_animation_player:
		return
	
	if !vm_shoot_animation_name:
		return
	
	if !raycast:
		return
	
	m_animation_tree.set("parameters/" + m_shoot_oneshot_name + "/request"
	, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	vm_animation_player.play(vm_shoot_animation_name)
	
	var collider:Node3D = raycast.get_collider()
	if !collider:
		return
