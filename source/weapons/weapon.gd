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

@export var audio_player:AudioStreamPlayer3D
@export var cooldown_timer:Timer

## The model for the weapon when it's held in 1st-person
@export var viewmodel:Node3D

## The model for the weapon when it's held in 3rd-person
@export var handheld_model:Node3D

## The model for the weapon when it's not active and sits on the 
## character's model. For example, on their belt.
@export var decoration_model:Node3D

var active:bool = false

signal just_fired


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
	
	if !viewmodel:
		return
	
	if !handheld_model:
		return
	
	emit_signal("just_fired")
	
	if m_fire_anim_name:
		m_animation_tree.set("parameters/" + m_fire_oneshot_name + "/request"
		, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if vm_fire_anim_name:
		vm_animation_player.play(vm_fire_anim_name)
	
	if audio_player:
		audio_player.play()
	
	if cooldown_timer:
		cooldown_timer.start()


func set_active(value:bool) -> void:
	active = value
	
	viewmodel.visible = active
	handheld_model.visible = active
	
	if decoration_model:
		decoration_model.visible = !active
	
	if !active:
		return
	
	var root:AnimationRootNode = m_animation_tree.tree_root
	var fire_animation_node:AnimationNodeAnimation = root.get_node(m_fire_anim_node_name)
	var hold_animation_node:AnimationNodeAnimation = root.get_node(m_hold_anim_node_name)
	
	fire_animation_node.animation = m_fire_anim_name
	hold_animation_node.animation = m_hold_anim_name
	
	vm_animation_player.play(vm_hold_anim_name)
