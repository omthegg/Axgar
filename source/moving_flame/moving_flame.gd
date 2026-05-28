extends CharacterBody3D

@export var size_ramp:CurveTexture

@onready var timer:Timer = $Timer

var active:bool = false


func _ready() -> void:
	set_active(false)


func _physics_process(_delta: float) -> void:
	if active:
		move_and_slide()


func _process(_delta: float) -> void:
	if active:
		var point = (timer.wait_time - timer.time_left) / timer.wait_time
		var size:float = size_ramp.curve.sample(point)
		$MeshInstance3D.mesh.size = Vector2.ONE * size


func set_active(value:bool) -> void:
	active = value
	visible = active
	timer.start()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !active:
		return


func _on_timer_timeout() -> void:
	active = false
	hide()
