extends Node3D

@onready var debug_canvas_layer:CanvasLayer = $DebugCanvasLayer

@onready var console_canvas_layer:CanvasLayer = $ConsoleCanvasLayer
@onready var console_line_edit:LineEdit = $ConsoleCanvasLayer/Console/LineEdit


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if console_canvas_layer.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			console_canvas_layer.hide()
			return
		
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("console"):
		console_canvas_layer.visible = !console_canvas_layer.visible
		console_line_edit.grab_focus()
		console_line_edit.text = ""
