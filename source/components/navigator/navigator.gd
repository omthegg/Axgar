extends Node3D
class_name Navigator

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var character:Character = get_parent()
@onready var target_looker:Node3D = $TargetLooker

func _ready() -> void:
	nav_agent.max_speed = character.run_speed
	character.running = true


func go_near_target(target:Node3D) -> void:
	nav_agent.target_position = target.global_position


func _physics_process(_delta: float) -> void:
	var destination:Vector3 = nav_agent.get_next_path_position()
	var difference:Vector3 = destination - character.global_position
	var direction:Vector3 = difference.normalized() * Vector3(1.0, 0.0, 1.0)
	character.direction = direction
	
	if !nav_agent.is_navigation_finished():
		#target_looker.look_at(character.global_position + direction)
		#var animated_rotation:Vector3 = Vector3.ZERO
		#animated_rotation.y = lerp_angle(character.global_rotation.y, target_looker.global_rotation.y, 8.0 * delta)
		#character.global_rotation = animated_rotation
		character.look_at(character.global_position + direction)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		go_near_target(Global.scene_manager.hushang)
