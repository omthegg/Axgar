extends Node3D

@onready var light:SpotLight3D = $SpotLight3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		light.visible = !light.visible
