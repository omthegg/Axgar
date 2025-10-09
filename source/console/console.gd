extends Control

@onready var line_edit:LineEdit = $LineEdit
@onready var text_edit:TextEdit = $TextEdit


func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.text = ""
	text_edit.text += new_text
