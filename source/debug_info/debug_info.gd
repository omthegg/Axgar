extends Control

@onready var fps_label:Label = $FPSLabel
@onready var draw_calls_label:Label = $DrawCallsLabel
@onready var primitives_label:Label = $PrimitivesLabel
@onready var vram_usage_label:Label = $VRAMUsageLabel
@onready var process_time_label:Label = $ProcessTimeLabel
@onready var label:Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	#fps_label.text = "FPS: " + str(int(Engine.get_frames_per_second()))
	var fps_text:String = "FPS: " + str(int(Engine.get_frames_per_second()))
	var draw_calls:float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var draw_calls_text:String = "Draw calls: " + str(int(draw_calls))
	#draw_calls_label.text = "Draw calls: " + str(int(draw_calls))
	var primitives:float = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	var primitives_text:String = "Primitives: " + str(int(primitives))
	#primitives_label.text = "Primitives: " + str(int(primitives))
	var vram_usage:float = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	var vram_text:String = "VRAM usage: ~" + str(int(vram_usage/1000000.0)) + "MB"
	#vram_usage_label.text = "VRAM usage: ~" + str(int(vram_usage/1000000.0)) + "MB"
	var process_time:float = Performance.get_monitor(Performance.TIME_PROCESS)
	var process_time_text:String = "Process time: " + str(process_time*1000.0) + "ms"
	#process_time_label.text = "Process time: " + str(process_time*1000.0) + "ms"
	label.text = (fps_text + "\n" + draw_calls_text + "\n"
	 + primitives_text + "\n" + vram_text + "\n" + process_time_text)
