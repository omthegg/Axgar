extends Node3D

var time:float = 0.0
var noise:FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	$AnimatedSprite3D.play("fire")
	$AnimatedSprite3D2.play("fire")
	$AnimatedSprite3D3.play("fire")
	$AnimatedSprite3D4.play("fire")
	
	var i:int = 0
	for x in 10:
		for z in 10:
			var b:Basis = Basis()
			var t:Transform3D = Transform3D(b, Vector3(x/2.0, position.y, z/2.0))
			t.origin += Vector3(randf_range(-0.25, 0.25), 0.0, randf_range(-0.25, 0.25))
			#var d:float = deg_to_rad(20.0)
			#t = t.rotated_local(Vector3(1.0, 0.0, 0.0), randf_range(-d, d))
			$MultiMeshInstance3D.multimesh.set_instance_transform(i, t)
			var camera_position:Vector3 = get_tree().root.get_camera_3d().global_position # + Vector3(0.0, -2.0, 0.0)
			$MultiMeshInstance3D.multimesh.mesh.material.set_shader_parameter("player_position", camera_position)
			i += 1
	#$Sprite3D.modulate = Color.ORANGE


func _physics_process(delta: float) -> void:
	time += delta
	
	$Sprite3D.texture.noise.seed = int(time * 10)
	
	var looking_position:Vector3 = get_tree().root.get_camera_3d().global_position
	looking_position.y = $MeshInstance3D.global_position.y
	#$MeshInstance3D.look_at(looking_position)
	
	#var shader_noise:FastNoiseLite = $MeshInstance3D2.material_override.get_shader_parameter("noise_texture").noise
	#shader_noise.seed = int(time * 10)
	#shader_noise.offset.y += 100.0 * delta
