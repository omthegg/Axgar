extends Node3D

var camera:Camera3D
var character:CharacterBody3D

var hb_x_value:float = 0.0
var hb_y_value:float = 0.0

var hb_amount:float = 0.015

var hb_time:float = 0.0
var hb_time_m:float = 9.00 # hb_time multiplier


func _physics_process(delta:float) -> void:
	head_bob(delta)


func head_bob(delta:float) -> void:
	if not character:
		character = get_parent().get_parent().get_parent()
	elif character.is_on_floor():
		var speed:float = character.velocity.length()
		
		if speed > 0.1:
			hb_time += delta
		else:
			hb_time = 0.0
		
		hb_x_value = speed * hb_amount/2 * sin(hb_time * hb_time_m)
		hb_y_value = speed * hb_amount * sin(hb_time * 2 * hb_time_m)
		
		#print(hb_x_value, hb_y_value)
		
		if camera:
			camera.position.x = lerpf(camera.position.x, hb_x_value, 10.0*delta)
			camera.position.y = lerpf(camera.position.y, hb_y_value, 10.0*delta)
