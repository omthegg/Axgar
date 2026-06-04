extends Node3D

@onready var raycasts:Node3D = $RayCasts
@onready var multimesh_instance:MultiMeshInstance3D = $MultiMeshInstance3D
@onready var rotation_helper:Node3D = $RotationHelper

class Flame:
	var raycast:RayCast3D
	var velocity:Vector3 = Vector3.ZERO

var flames:Array[Flame]

var flame_count:int = 128
var current_flame:int = 0

var gravity:float = -ProjectSettings["physics/3d/default_gravity"]

func _ready() -> void:
	multimesh_instance.multimesh.visible_instance_count = 0
	multimesh_instance.multimesh.instance_count = flame_count
	multimesh_instance.multimesh.visible_instance_count = -1
	for i in flame_count:
		var flame:Flame = Flame.new()
		
		var raycast:RayCast3D = RayCast3D.new()
		raycasts.add_child(raycast)
		flame.raycast = raycast
		
		flames.append(flame)


func _physics_process(delta: float) -> void:
	update_flames(delta)


func _process(_delta: float) -> void:
	display_flames()


func create_flame(pos:Vector3, velocity:Vector3, exception:CollisionObject3D) -> void:
	var flame:Flame = flames[current_flame]
	flame.raycast.add_exception(exception)
	flame.raycast.global_position = pos
	flame.velocity = velocity
	flame.raycast.target_position = flame.velocity.normalized()
	flame.raycast.enabled = false
	
	current_flame += 1
	if current_flame > (flames.size() - 1):
		current_flame = 0


func update_flames(delta:float) -> void:
	for flame:Flame in flames:
		if flame.raycast.is_colliding():
			flame.velocity = Vector3.ZERO
			continue
		
		flame.raycast.enabled = true
		
		flame.velocity.y += gravity * delta * 0.05
		flame.raycast.global_position += flame.velocity
		flame.raycast.target_position = flame.velocity.normalized() / 2.0


func display_flames() -> void:
	for i in flames.size():
		var flame:Flame = flames[i]
		var t:Transform3D = Transform3D()
		t = t.translated(flame.raycast.global_position)
		if (flame.velocity.length() > 0.0) and (flame.velocity.normalized() != Vector3.UP) and (flame.velocity.normalized() != Vector3.DOWN):
			rotation_helper.look_at(flame.velocity)
			# Remember, order of euler is YXZ
			t = t.rotated_local(Vector3.UP, rotation_helper.rotation.y)
			t = t.rotated_local(Vector3.RIGHT, rotation_helper.rotation.x + deg_to_rad(90.0))
			t = t.rotated_local(Vector3.BACK, rotation_helper.rotation.z)
		
		multimesh_instance.multimesh.set_instance_transform(i, t)
