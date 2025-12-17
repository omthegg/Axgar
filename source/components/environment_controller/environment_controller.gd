extends Node3D

@export var fire_flicker:bool = false:
	set(value):
		$AmbientLight.visible = !value
		$FireFlickerLight.visible = value
		fire_flicker = value

@onready var world_environment:WorldEnvironment = $WorldEnvironment
@onready var fire_flicker_rect = $FireFlickerRect
@onready var fire_flicker_light = $FireFlickerLight
@onready var ambient_light = $AmbientLight

var time:float = 0.0
var fire_noise:FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	world_environment.environment.ambient_light_source = Environment.AmbientSource.AMBIENT_SOURCE_DISABLED
	fire_flicker_light.light_color = Color.ORANGE
	if !fire_flicker:
		ambient_light.show()


func _process(delta: float) -> void:
	time += delta
	var camera:Camera3D = get_tree().root.get_camera_3d()
	if fire_flicker:
		fire_flicker_light.global_position = camera.global_position
		animate_fire_flicker()
	else:
		ambient_light.global_position = camera.global_position


func animate_fire_flicker() -> void:
	var light_energy:float = 0.05 + abs(fire_noise.get_noise_1d(time * 50.0))/7.0
	fire_flicker_light.light_energy = light_energy
