extends CharacterBody3D
class_name Character

@export var walk_speed:float = 5.0
@export var run_speed:float = 9.0
@export var mass:float = 75.0
@export var jump_speed:float = 5.0

var speed:float = walk_speed
var running:bool = false
var direction:Vector3 = Vector3.ZERO
var ko_meter:float = 0.0 ## If this reacher 10.0, the character gets KO'ed

func _physics_process(delta: float) -> void:
	manage_ko(delta)
	
	# Add the gravity.
	# In a vaccum, all objects fall at the same speed.
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	if running:
		speed = run_speed
	else:
		speed = walk_speed
	
	velocity.x = lerpf(velocity.x, direction.x * speed, 15.0 * delta)
	velocity.z = lerpf(velocity.z, direction.z * speed, 15.0 * delta)
	
	move_and_slide()
	
	# Handle RigidBody collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print(collision.get_normal())
		if collision.get_normal().y > 0.5:
			continue
		
		if collision.get_collider() is RigidBody3D:
			collision.get_collider().apply_force(collision.get_normal() * -300)


func manage_ko(delta:float) -> void:
	if ko_meter > 0.0:
		ko_meter -= delta/2.0
	elif ko_meter < 0.0:
		ko_meter = 0.0


func jump() -> void:
	if !is_on_floor():
		return
	
	velocity.y = jump_speed
