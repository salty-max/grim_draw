extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var is_minimum_drag_time_elapsed := false

func enter() -> void:
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
		
	card_ui.card_visuals.set_stylebox(card_ui.DRAGGING_STYLEBOX)
	Events.card_drag_started.emit(card_ui)
	
	is_minimum_drag_time_elapsed = false
	var threshold_timer = get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): is_minimum_drag_time_elapsed = true)
	

func exit() -> void:
	Events.card_drag_ended.emit(card_ui)

	
func on_input(event: InputEvent) -> void:
	var is_single_targeted := card_ui.card.is_single_targeted()
	var is_mouse_motion := event is InputEventMouseMotion
	var is_cancelled := event.is_action_pressed("rmb")
	var is_confirmed := event.is_action_released("lmb") or event.is_action_pressed("lmb")
	
	if is_single_targeted and is_mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	if is_mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		
	if is_cancelled:
		transition_requested.emit(self, CardState.State.BASE)
	elif is_minimum_drag_time_elapsed and is_confirmed:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
