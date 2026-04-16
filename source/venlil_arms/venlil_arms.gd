extends Node3D

var character:Character

func _physics_process(_delta: float) -> void:
	if !character:
		return
