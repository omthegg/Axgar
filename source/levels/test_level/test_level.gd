extends Node3D


func _ready() -> void:
	Global.set_player($NavigationRegion3D/VenlilTemplate)
	#$NavigationRegion3D/CSGCombiner3D.queue_free()
