extends Node

@onready var scene_manager:Node3D = get_tree().root.get_node("SceneManager")

var mouse_sensitivity:float = 0.005

var player:Character

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func set_player(character:Character) -> void:
	character.is_player = true
	character.make_models_first_person()
	
	if character.get("character_controller"):
		character.character_controller.camera.make_current()
	
	if player:
		player.is_player = false
		player.make_models_third_person()
	
	player = character
