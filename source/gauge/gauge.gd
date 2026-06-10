extends Node3D

@onready var pointer:MeshInstance3D = $gauge/Pointer

var progress:float = 0.0:
	set(value):
		progress = value
		pointer.rotation_degrees.z = progress * 180.0 - 90.0
