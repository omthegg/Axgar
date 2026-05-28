extends CharacterBody3D

@export var size_ramp:CurveTexture
@export var flame_size:float = 1.0

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
		$MeshInstance3D.mesh.size = Vector2.ONE * flame_size * size


func set_active(value:bool) -> void:
	active = value
	visible = active
	timer.start()
	$MeshInstance3D.mesh.size = Vector2.ONE * flame_size
	#$CollisionShape3D.shape.radius = flame_size / 2.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !active:
		return


func _on_timer_timeout() -> void:
	active = false
	hide()
