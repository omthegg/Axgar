extends Node3D
class_name ViewmodelAnimator

@export var character:Character
@export var arms:Node3D
@export var arms_default_position:Vector3

var hb_x_value:float = 0.0
var hb_y_value:float = 0.0

# hb stands for hand bob
var hb_amount:float = 0.002

var hb_time:float = 0.0
var hb_time_m:float = 7.00 # hb_time multiplier


func _physics_process(delta:float) -> void:
	hand_bob(delta)


func hand_bob(delta:float) -> void:
	if !character or !arms:
		return
	
	if character.is_on_floor():
		var speed:float = character.velocity.length()
		
		if speed > 0.1:
			hb_time += delta
		else:
			hb_time = 0.0
		
		hb_x_value = speed * hb_amount * sin(hb_time * hb_time_m)
		hb_y_value = speed * hb_amount * sin(hb_time * 2 * hb_time_m)
		
		#print(hb_x_value, hb_y_value)
	else:
		hb_x_value = 0.0
		hb_y_value = 0.0
	
	arms.position.x = lerpf(arms.position.x, 
	hb_x_value + arms_default_position.x, 10.0*delta)
	
	arms.position.y = lerpf(arms.position.y,
	hb_y_value + arms_default_position.y, 10.0*delta)
