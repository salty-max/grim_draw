extends CardState

var is_played: bool

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "RELEASED"
	is_played = false
	
	if not card_ui.targets.is_empty():
		is_played = true
		print("play card for target(s)", card_ui.targets)
		
		
func on_input(_event: InputEvent) -> void:
	if is_played:
		return
		
	transition_requested.emit(self, CardState.State.BASE)
