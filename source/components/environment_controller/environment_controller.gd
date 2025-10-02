extends Node3D

@export var fire_flicker:bool = false

@onready var world_environment:WorldEnvironment = $WorldEnvironment

var time:float = 0.0
var fire_noise:FastNoiseLite = FastNoiseLite.new()


func _process(delta: float) -> void:
	time += delta
	
	if fire_flicker:
		animate_fire_flicker()


func animate_fire_flicker() -> void:
	world_environment.environment.ambient_light_color = Color.ORANGE
	var light_energy:float = 0.1 + abs(fire_noise.get_noise_1d(time * 30))/10
	world_environment.environment.ambient_light_energy = light_energy
