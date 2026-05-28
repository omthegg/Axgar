extends Weapon

## The RayCast3D from which the weapon will shoot.
@export var raycast:RayCast3D

func _on_just_fired() -> void:
	if raycast:
		var collider:Node3D = raycast.get_collider()
		
		if collider:
			if collider.is_in_group("glass"):
				collider.shatter()
			else:
				var p:Vector3 = raycast.get_collision_point()
				var n:Vector3 = raycast.get_collision_normal()
				Global.scene_manager.decal_manager.add_bullet_hole(p, n)
