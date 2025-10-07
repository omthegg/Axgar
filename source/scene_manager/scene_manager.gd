extends Node3D

@onready var debug_canvas_layer:CanvasLayer = $DebugCanvasLayer
@onready var fps_label:Label = $DebugCanvasLayer/Control/FPSLabel
@onready var draw_calls_label:Label = $DebugCanvasLayer/Control/DrawCallsLabel
@onready var primitives_label:Label = $DebugCanvasLayer/Control/PrimitivesLabel


func _process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(int(Engine.get_frames_per_second()))
	var draw_calls:float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	draw_calls_label.text = "Draw calls: " + str(int(draw_calls))
	var primitives:float = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	primitives_label.text = "Primitives: " + str(int(primitives))
