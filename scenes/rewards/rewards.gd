extends Control


func _on_back_button_pressed() -> void:
	Events.rewards_exited.emit()
