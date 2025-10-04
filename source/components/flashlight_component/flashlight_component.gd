extends Node3D

@onready var light:SpotLight3D = $SpotLight3D


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("flashlight"):
		light.visible = !light.visible
