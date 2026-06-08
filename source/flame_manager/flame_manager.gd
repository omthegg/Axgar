extends Node3D

@onready var raycasts:Node3D = $RayCasts
@onready var fire_multimesh_instance:MultiMeshInstance3D = $FireMultiMeshInstance3D
@onready var fuel_mmi:MultiMeshInstance3D = $FuelMultiMeshInstance3D
@onready var fuel_inbetween_mmi:MultiMeshInstance3D = $FuelInbetweenMultiMeshInstance3D
@onready var rotation_helper:Node3D = $RotationHelper

class Flame:
	var raycast:RayCast3D
	var velocity:Vector3 = Vector3.ZERO
	
	func is_active() -> bool:
		return (velocity.length() > 0.0) and (velocity.normalized() != Vector3.UP) and (velocity.normalized() != Vector3.DOWN)

var flames:Array[Flame]
var active_flames:Array[Flame]

var flame_count:int = 256
var current_flame:int = 0

var gravity:float = -ProjectSettings["physics/3d/default_gravity"]

func _ready() -> void:
	fire_multimesh_instance.multimesh.visible_instance_count = 0
	fire_multimesh_instance.multimesh.instance_count = flame_count
	fire_multimesh_instance.multimesh.visible_instance_count = -1
	
	fuel_mmi.multimesh.visible_instance_count = 0
	fuel_mmi.multimesh.instance_count = flame_count
	fuel_mmi.multimesh.visible_instance_count = -1
	
	fuel_inbetween_mmi.multimesh.visible_instance_count = 0
	fuel_inbetween_mmi.multimesh.instance_count = 1000
	fuel_inbetween_mmi.multimesh.visible_instance_count = -1
	
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
	
	active_flames.append(flame)
	
	current_flame += 1
	if current_flame > (flames.size() - 1):
		current_flame = 0


func update_flames(delta:float) -> void:
	for flame:Flame in active_flames:
		if flame.raycast.is_colliding():
			flame.velocity = Vector3.ZERO
			
			if !flame.raycast.get_collider().is_in_group("glass"):
				active_flames.erase(flame)
			
			continue
		
		flame.raycast.enabled = true
		
		flame.velocity.y += gravity * delta * 0.05
		flame.raycast.global_position += flame.velocity
		flame.raycast.target_position = flame.velocity.normalized() / 2.0


func display_flames() -> void:
	#fuel_inbetween_mmi.multimesh.instance_count = 0
	#fuel_inbetween_mmi.multimesh.instance_count = 1000
	var inbetweens:PackedVector3Array = []
	
	for i in flames.size():
		var flame:Flame = flames[i]
		var t:Transform3D = Transform3D()
		t = t.translated(flame.raycast.global_position)
		if flame.is_active():
			rotation_helper.look_at(flame.velocity)
			# Remember, order of euler is YXZ
			t = t.rotated_local(Vector3.UP, rotation_helper.rotation.y)
			t = t.rotated_local(Vector3.RIGHT, rotation_helper.rotation.x + deg_to_rad(90.0))
			t = t.rotated_local(Vector3.BACK, rotation_helper.rotation.z)
		
			if i != 0:
				if flames[i - 1].is_active():
					var previous:Vector3 = flames[i - 1].raycast.global_position
					var current:Vector3 = flames[i].raycast.global_position
					if current.distance_to(previous) > 0.3:
						var inbetweens_count:int = int(current.distance_to(previous) / 0.3)
						for j in inbetweens_count:
							var interp:Vector3 = previous + (j + 1) * (current - previous) / inbetweens_count
							inbetweens.append(interp)
		
		fuel_mmi.multimesh.set_instance_transform(i, t)
	
	fuel_inbetween_mmi.multimesh.visible_instance_count = inbetweens.size()
	for i in inbetweens.size():
		#print(inbetweens[i])
		var t:Transform3D = Transform3D()
		t = t.translated(inbetweens[i])
		fuel_inbetween_mmi.multimesh.set_instance_transform(i, t)
