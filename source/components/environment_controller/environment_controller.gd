extends Node3D

@export var fire_flicker:bool = false:
	set(value):
		#$AmbientLight.visible = !value
		$FireFlickerLight.visible = value
		#$AmbientLight.visible = !value
		fire_flicker = value

@onready var world_environment:WorldEnvironment = $WorldEnvironment
@onready var fire_flicker_rect = $FireFlickerRect
@onready var fire_flicker_light = $FireFlickerLight
@onready var ambient_light = $AmbientLight
@onready var smoke_zone_detector:Area3D = $SmokeZoneDetector
@onready var smoke_rect:ColorRect = $CanvasLayer/SmokeRect

var time:float = 0.0
var fire_noise:FastNoiseLite = FastNoiseLite.new()
var fire_flicker_base_energy:float = 0.5

var camera:Camera3D
var camera_in_smoke:bool = false


func _ready() -> void:
	world_environment.environment.ambient_light_source = Environment.AmbientSource.AMBIENT_SOURCE_DISABLED
	
	if fire_flicker:
		$AmbientLight.hide()
	
	fire_flicker_light.light_color = Color.DARK_ORANGE
	#ambient_light.light_color = Color.LIGHT_STEEL_BLUE
	#if !fire_flicker:
	#	ambient_light.show()


func _physics_process(_delta: float) -> void:
	if is_instance_valid(camera):
		smoke_zone_detector.global_position = camera.global_position
	
	camera_in_smoke = smoke_zone_detector.has_overlapping_bodies()


func _process(delta: float) -> void:
	time += delta
	camera = get_tree().root.get_camera_3d()
	if fire_flicker:
		fire_flicker_light.global_position = camera.global_position
		animate_fire_flicker(delta)
	else:
		ambient_light.global_position = camera.global_position


func animate_fire_flicker(delta:float) -> void:
	if camera_in_smoke:
		#fire_flicker_light.omni_range = move_toward(fire_flicker_light.omni_range, 7.0, 300.0 * delta)
		#fire_flicker_base_energy = move_toward(fire_flicker_base_energy, 0.3, 1.0 * delta)
		fire_flicker_light.omni_range = 7.0
		fire_flicker_base_energy = 0.3
		smoke_rect.material.set_shader_parameter("alpha", move_toward(smoke_rect.material.get_shader_parameter("alpha"), 1.0, 1.5 * delta))
	else:
		#fire_flicker_light.omni_range = move_toward(fire_flicker_light.omni_range, 50.0, 300.0 * delta)
		#fire_flicker_base_energy = move_toward(fire_flicker_base_energy, 0.5, 1.0 * delta)
		fire_flicker_light.omni_range = 50.0
		fire_flicker_base_energy = 0.5
		smoke_rect.material.set_shader_parameter("alpha", move_toward(smoke_rect.material.get_shader_parameter("alpha"), 0.0, 1.5 * delta))
	
	var light_energy:float = fire_flicker_base_energy + abs(fire_noise.get_noise_1d(time * 50.0))/2.0
	fire_flicker_light.light_energy = light_energy
