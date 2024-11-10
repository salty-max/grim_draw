extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
		
	if card_ui.card:
		card_ui.set_stylebox(card_ui.BASE_STYLEBOX)	
	
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()
	
	
func on_gui_input(event: InputEvent) -> void:
	if not card_ui.is_playable or card_ui.is_disabled:
		return
	if event.is_action_pressed("lmb"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
		
		
func on_mouse_entered() -> void:
	if not card_ui.is_playable or card_ui.is_disabled:
		return
	card_ui.set_stylebox(card_ui.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.name, card_ui.card.tooltip_text)
	
	
func on_mouse_exited() -> void:
	if not card_ui.is_playable or card_ui.is_disabled:
		return
	card_ui.set_stylebox(card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
