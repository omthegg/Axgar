extends Weapon

@export var character_head:Node3D

@onready var flames:Node3D = $Flames

var flame_packed_scene:PackedScene = preload("res://source/moving_flame/moving_flame.tscn")

var flames_list:Array = []

var current_flame:int = 0

func _ready() -> void:
	for i in range(32):
		var flame:CharacterBody3D = flame_packed_scene.instantiate()
		flames.add_child(flame)
		flame.top_level = true
		flames_list.append(flame)


func _on_just_fired() -> void:
	var flame = flames_list[current_flame]
	
	flame.set_active(true)
	var pos:Vector3 = character_head.global_position - character_head.global_basis.z/20.0
	flame.global_position = pos
	flame.velocity = -character_head.global_basis.z * 12.0
	
	current_flame += 1
	
	if current_flame > 31:
		current_flame = 0
