extends Node3D

class_name CharacterControllerComponent

@export var camera_height:float = 0.0
@export var fov:int = 90
@export var has_flashlight:bool = false

@onready var character:Character = get_parent()
@onready var head:Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D
@onready var head_bobber:Node3D = $Head/HeadBobber
@onready var head_tilter:Node3D = $Head/HeadTilter
@onready var flashlight_component:Node3D = $Head/Camera3D/FlashlightComponent

var input_dir:Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head.position.y = camera_height
	camera.fov = fov
	#head_bobber.camera = camera
	head_tilter.camera = camera
	head_tilter.character_controller = self
	
	flashlight_component.visible = has_flashlight


func _physics_process(_delta:float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		character.jump()
	
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.direction = (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Running
	character.running = (Input.is_action_pressed("run") and input_dir.y < 0)


func _input(event) -> void:
	if event is InputEventMouseMotion:
		character.rotate_y(-event.relative.x*Global.mouse_sensitivity)
		head.rotate_x(-event.relative.y*Global.mouse_sensitivity)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
