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

@onready var audio_player:AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var shoot_timer:Timer = $ShootTimer


func shoot() -> void:
	if !shoot_timer.is_stopped():
		return
	
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
	
	if collider:
		if collider.is_in_group("glass"):
			collider.shatter()
		else:
			var p:Vector3 = raycast.get_collision_point()
			var n:Vector3 = raycast.get_collision_normal()
			Global.scene_manager.decal_manager.add_bullet_hole(p, n)
	
	audio_player.play()
	shoot_timer.start()
