@tool
extends Character

@export var is_exterminator:bool = false:
	set(value):
		is_exterminator = value
		if is_exterminator:
			set_materials(exterminator_material)
		else:
			set_materials(fur_material)

@export var fur_color:Color = Color.WHITE:
	set(value):
		fur_color = value
		configure_model()

@export_range(0.5, 2.0, 0.01) var size:float = 1.0:
	set(value):
		size = value
		configure_model()

@onready var character_controller:CharacterControllerComponent = $CharacterControllerComponent

@onready var animation_tree:AnimationTree = $AnimationTree

@onready var tp_body_parts:Array = [
	$Venlil/Armature/Skeleton3D/Head/Head_m,
	$Venlil/Armature/Skeleton3D/Hand_L/Hand_L_m,
	$Venlil/Armature/Skeleton3D/Arm2_L/Arm2_L_m,
	$Venlil/Armature/Skeleton3D/Arm1_L/Arm1_L_m,
	$Venlil/Armature/Skeleton3D/Foot_L/Foot_L_m,
	$Venlil/Armature/Skeleton3D/Leg2_L/Leg2_L_m,
	$Venlil/Armature/Skeleton3D/Leg1_L/Leg1_L_m,
	$Venlil/Armature/Skeleton3D/Tail3/Tail3_m,
	$Venlil/Armature/Skeleton3D/Tail2/Tail2_m,
	$Venlil/Armature/Skeleton3D/Tail1/Tail1_m,
	$Venlil/Armature/Skeleton3D/Hand_R/Hand_R_m,
	$Venlil/Armature/Skeleton3D/Arm2_R/Arm2_R_m,
	$Venlil/Armature/Skeleton3D/Arm1_R/Arm1_R_m,
	$Venlil/Armature/Skeleton3D/Foot_R/Foot_R_m,
	$Venlil/Armature/Skeleton3D/Leg2_R/Leg2_R_m,
	$Venlil/Armature/Skeleton3D/Leg1_R/Leg1_R_m,
	$Venlil/Armature/Skeleton3D/Torso/Torso_m
]

@onready var fp_body_parts:Array = [
	$SubViewportContainer/SubViewport/Camera3D/venlil_arms/Armature_vm/Skeleton3D/Hand_L/Hand_L_vm,
	$SubViewportContainer/SubViewport/Camera3D/venlil_arms/Armature_vm/Skeleton3D/Arm2_L/Arm2_L_vm,
	$SubViewportContainer/SubViewport/Camera3D/venlil_arms/Armature_vm/Skeleton3D/Arm1_L/Arm1_L_vm,
	$SubViewportContainer/SubViewport/Camera3D/venlil_arms/Armature_vm/Skeleton3D/Hand_R/Hand_R_vm,
	$SubViewportContainer/SubViewport/Camera3D/venlil_arms/Armature_vm/Skeleton3D/Arm2_R/Arm2_R_vm,
	$SubViewportContainer/SubViewport/Camera3D/venlil_arms/Armature_vm/Skeleton3D/Arm1_R/Arm1_R_vm
]

@onready var arms:Node3D = $SubViewportContainer/SubViewport/Camera3D/venlil_arms
@onready var viewmodel_camera:Camera3D = $SubViewportContainer/SubViewport/Camera3D

var fur_material:StandardMaterial3D = preload("res://source/venlil_template/venlil_fur.tres")
var exterminator_material:StandardMaterial3D = preload("res://source/venlil_template/exterminator_suit.tres")

enum Items {EMPTY, PISTOL, FLAMER}
var current_item:Items = Items.PISTOL


func _ready() -> void:
	super()
	if is_exterminator:
		set_materials(exterminator_material)
	else:
		set_materials(fur_material)
	
	configure_model()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	animate()
	viewmodel_camera.global_transform = character_controller.camera.global_transform


func animate() -> void:
	var ratio:float = velocity.length()/run_speed
	animation_tree["parameters/WalkSpeed/blend_amount"] = ratio
	if animation_tree["parameters/WalkSpeed/blend_amount"] > 1.0:
		animation_tree["parameters/WalkSpeed/blend_amount"] = 1.0


func configure_model() -> void:
	if !is_exterminator:
		$Venlil/Armature/Skeleton3D/Head/Head_m.material_override.albedo_color = fur_color
	
	$Venlil.scale = Vector3.ONE * size
	$CollisionShape3D.scale = Vector3.ONE * size
	$CollisionShape3D.position.y = 0.75 * size


func set_materials(material:Material) -> void:
	for body_part:MeshInstance3D in tp_body_parts:
		body_part.material_override = material
	
	#var fp_material:Material = material.duplicate()
	#fp_material.use_z_clip_scale = true
	#fp_material.z_clip_scale = 0.5
	
	for body_part:MeshInstance3D in fp_body_parts:
		body_part.material_override = material
	
	#print(fp_material.z_clip_scale)


# I only made these into separate functions because I couldn't
# think of a good name for the function
func make_models_first_person() -> void:
	#arms.show()
	for body_part:MeshInstance3D in tp_body_parts:
		body_part.set_layer_mask_value(1, false)
		body_part.set_layer_mask_value(3, true)


func make_models_third_person() -> void:
	arms.hide()
	for body_part:MeshInstance3D in tp_body_parts:
		body_part.set_layer_mask_value(1, true)
		body_part.set_layer_mask_value(3, false)
