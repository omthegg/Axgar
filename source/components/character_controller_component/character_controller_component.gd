extends Node3D

class_name CharacterControllerComponent

@export var camera_height:float = 0.0
@export var walking_speed:float = 5.0
@export var running_speed:float = 9.0
@export var mass:int = 75
@export var jump_speed:float = 5
@export var fov:int = 80

@onready var character:CharacterBody3D = get_parent()
@onready var head:Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D
@onready var head_bobber:Node3D = $Head/HeadBobber
@onready var head_tilter:Node3D = $Head/HeadTilter

var speed:float = walking_speed

var input_dir:Vector2
var direction:Vector3

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head.position.y = camera_height
	camera.fov = fov
	head_bobber.camera = camera
	head_tilter.head = head
	head_tilter.character_controller = self


func _physics_process(delta:float) -> void:
	# Add the gravity.
	# In a vaccum, all objects fall at the same speed.
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = jump_speed
	
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Running
	if Input.is_action_pressed("run") and input_dir.y < 0:
		speed = running_speed
	else:
		speed = walking_speed
	
	#if direction:
	character.velocity.x = lerpf(character.velocity.x, direction.x * speed, 15.0 * delta)
	character.velocity.z = lerpf(character.velocity.z, direction.z * speed, 15.0 * delta)
	#else:
	#	character.velocity.x = move_toward(character.velocity.x, 0, speed)
	#	character.velocity.z = move_toward(character.velocity.z, 0, speed)
	
	character.move_and_slide()
	
	for i in character.get_slide_collision_count():
			var collision = character.get_slide_collision(i)
			if collision.get_collider() is RigidBody3D:
				collision.get_collider().apply_force(collision.get_normal() * -50)



func _input(event) -> void:
	if event is InputEventMouseMotion:
		character.rotate_y(-event.relative.x*Global.mouse_sensitivity)
		head.rotate_x(-event.relative.y*Global.mouse_sensitivity)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
