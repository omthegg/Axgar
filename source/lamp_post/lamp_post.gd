extends StaticBody3D

@onready var raycast:RayCast3D = $RayCast3D
@onready var light:OmniLight3D = $OmniLight3D


# This is to compensate for not having shadows on viewmodels
func _physics_process(_delta: float) -> void:
	var camera:Camera3D = get_tree().root.get_camera_3d()
	
	raycast.target_position = to_local(camera.global_position)
	
	# 225 is 15^2. 15 is the range of the OmniLight
	if light.global_position.distance_squared_to(camera.global_position) > 225.0:
		light.show()
		return
	
	if !raycast.is_colliding():
		light.show()
		return
		
	if (raycast.get_collider() is Character):
		light.show()
		return
	
	light.hide()
