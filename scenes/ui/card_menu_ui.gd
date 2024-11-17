class_name CardMenuUI
extends CenterContainer

signal popup_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var visuals: CardVisuals = $Visuals


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
		
	card = value
	visuals.card = card


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		popup_requested.emit(card)


func _on_visuals_mouse_entered() -> void:
	visuals.set_stylebox(HOVER_STYLEBOX)


func _on_visuals_mouse_exited() -> void:
	visuals.set_stylebox(BASE_STYLEBOX)
