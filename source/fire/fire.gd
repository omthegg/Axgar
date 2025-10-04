extends Node3D

var time:float = 0.0
var noise:FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	$AnimatedSprite3D.play("fire")
	$AnimatedSprite3D2.play("fire")
	$AnimatedSprite3D3.play("fire")
	$AnimatedSprite3D4.play("fire")


func _physics_process(delta: float) -> void:
	time += delta
	
	noise.seed = int(time * 10)
	$Sprite3D.texture = ImageTexture.create_from_image(noise.get_image(64, 64))
