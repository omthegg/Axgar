extends Node3D
class_name Weapon

## The AnimationTree for the 3rd-person model.
@export var m_animation_tree:AnimationTree

## The name of the shooting oneshot in the AnimationTree of the
## 3rd-person model.
@export var m_fire_oneshot_name:StringName

## The name of the holding animation node in the 3rd-person
## AnimationNodeBlendTree
@export var m_hold_anim_node_name:StringName

## The name of the 3rd-person holding animation for the weapon
@export var m_hold_anim_name:StringName

## The name of the firing animation node in the 3rd-person
## AnimationNodeBlendTree
@export var m_fire_anim_node_name:StringName

## The name of the 3rd-person shooting animation for the weapon
@export var m_fire_anim_name:StringName

## The AnimationPlayer for the 1st-person/view model.
@export var vm_animation_player:AnimationPlayer

## The name of the 1st-person holding animation for the weapon
@export var vm_hold_anim_name:StringName

## The name of the 1st-person firing animation for the weapon
@export var vm_fire_anim_name:StringName

## The RayCast3D from which the weapon will shoot.
@export var raycast:RayCast3D

@export var audio_player:AudioStreamPlayer3D
@export var cooldown_timer:Timer

var active:bool = false


func shoot() -> void:
	if !active:
		return
	
	if cooldown_timer:
		if !cooldown_timer.is_stopped():
			return
	
	if !m_animation_tree:
		return
	
	if !vm_animation_player:
		return
	
	if !raycast:
		return
	
	if m_fire_anim_name:
		m_animation_tree.set("parameters/" + m_fire_oneshot_name + "/request"
		, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if vm_fire_anim_name:
		vm_animation_player.play(vm_fire_anim_name)
	
	if raycast:
		var collider:Node3D = raycast.get_collider()
		
		if collider:
			if collider.is_in_group("glass"):
				collider.shatter()
			else:
				var p:Vector3 = raycast.get_collision_point()
				var n:Vector3 = raycast.get_collision_normal()
				Global.scene_manager.decal_manager.add_bullet_hole(p, n)
	
	if audio_player:
		audio_player.play()
	
	if cooldown_timer:
		cooldown_timer.start()


func set_active(value:bool) -> void:
	active = value
	if !active:
		return
	
	var root:AnimationRootNode = m_animation_tree.tree_root
	var fire_animation_node:AnimationNodeAnimation = root.get_node(m_fire_anim_node_name)
	var hold_animation_node:AnimationNodeAnimation = root.get_node(m_hold_anim_node_name)
	
	fire_animation_node.animation = m_fire_anim_name
	hold_animation_node.animation = m_hold_anim_name
	
	vm_animation_player.play(vm_hold_anim_name)
