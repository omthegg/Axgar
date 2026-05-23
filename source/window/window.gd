@tool
extends StaticBody3D

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D
@onready var collision_shape:CollisionShape3D = $CollisionShape3D
@onready var audio_player:AudioStreamPlayer3D = $AudioStreamPlayer3D

var shattered:bool = false

@export var size:Vector2 = Vector2(1.0, 1.0):
	set(value):
		size = value
		if !mesh_instance:
			return
		if !collision_shape:
			return
		
		mesh_instance.mesh.size = size
		collision_shape.shape.size.x = size.x
		collision_shape.shape.size.y = size.y

func _ready() -> void:
	mesh_instance.mesh.size = size
	collision_shape.shape.size.x = size.x
	collision_shape.shape.size.y = size.y


func shatter() -> void:
	if shattered:
		return
	
	shattered = true
	collision_shape.disabled = true
	mesh_instance.material_override.set_shader_parameter("current_shatter_frame", 0)
	var tween:Tween = create_tween()
	tween.tween_property(mesh_instance, 
	"material_override:shader_parameter/current_shatter_frame",
	 43, 0.7)
	
	audio_player.play()
