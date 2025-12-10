extends Node3D

@export var fire_flicker:bool = false:
	set(value):
		if value:
			$WorldEnvironment.environment.ambient_light_source = Environment.AmbientSource.AMBIENT_SOURCE_DISABLED
		else:
			$WorldEnvironment.environment.ambient_light_source = Environment.AmbientSource.AMBIENT_SOURCE_COLOR
		$FireFlickerLight.visible = value
		fire_flicker = value

@onready var world_environment:WorldEnvironment = $WorldEnvironment
@onready var fire_flicker_rect = $FireFlickerRect
@onready var fire_flicker_light = $FireFlickerLight

var time:float = 0.0
var fire_noise:FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	fire_flicker_light.light_color = Color.ORANGE


func _process(delta: float) -> void:
	time += delta
	if fire_flicker:
		var camera:Camera3D = get_tree().root.get_camera_3d()
		fire_flicker_light.global_position = camera.global_position
		animate_fire_flicker()


func animate_fire_flicker() -> void:
	var light_energy:float = 0.05 + abs(fire_noise.get_noise_1d(time * 50.0))/7.0
	fire_flicker_light.light_energy = light_energy
