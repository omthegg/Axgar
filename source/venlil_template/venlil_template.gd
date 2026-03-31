extends Node3D

@export var fur_color:Color = Color.WHITE
@export_range(1.0, 2.0, 0.01) var size:float = 1.0
@export var character:Character
@export var character_controller:CharacterControllerComponent

@onready var animation_tree:AnimationTree = $AnimationTree

func _ready() -> void:
	$Venlil/Armature/Skeleton3D/Head_2/Head.material_override.albedo_color = fur_color
	if character_controller:
		position.z += 0.1


func _physics_process(_delta: float) -> void:
	animate()


func animate() -> void:
	if !character:
		return
	
	var ratio:float = character.velocity.length()/character.run_speed
	animation_tree["parameters/walk_speed/blend_amount"] = ratio
	if animation_tree["parameters/walk_speed/blend_amount"] > 1.0:
		animation_tree["parameters/walk_speed/blend_amount"] = 1.0
