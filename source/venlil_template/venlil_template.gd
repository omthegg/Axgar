@tool
extends Node3D

@export var fur_color:Color = Color.WHITE:
	set(value):
		fur_color = value
		configure_model()

@export_range(0.5, 2.0, 0.01) var size:float = 1.0:
	set(value):
		size = value
		configure_model()

@export var character:Character
@export var character_controller:CharacterControllerComponent

@onready var animation_tree:AnimationTree = $AnimationTree

func _ready() -> void:
	configure_model()
	if character_controller:
		position.z = 0.1


func _physics_process(_delta: float) -> void:
	animate()


func animate() -> void:
	if !character:
		return
	
	var ratio:float = character.velocity.length()/character.run_speed
	animation_tree["parameters/walk_speed/blend_amount"] = ratio
	if animation_tree["parameters/walk_speed/blend_amount"] > 1.0:
		animation_tree["parameters/walk_speed/blend_amount"] = 1.0


func configure_model() -> void:
	$Venlil/Armature/Skeleton3D/Head/Head_m.material_override.albedo_color = fur_color
	$Venlil.scale = Vector3.ONE * size
