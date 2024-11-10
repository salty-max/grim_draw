extends CardState

var is_played: bool

func enter() -> void:
	is_played = false
	
	if not card_ui.targets.is_empty():
		Events.tooltip_hide_requested.emit()
		is_played = true
		card_ui.play()
		
		
func on_input(_event: InputEvent) -> void:
	if is_played:
		return
		
	transition_requested.emit(self, CardState.State.BASE)
