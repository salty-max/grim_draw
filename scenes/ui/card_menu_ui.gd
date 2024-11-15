class_name CardMenuUI
extends CenterContainer

signal popup_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/ui/card_hover_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel: Panel = $Visuals/Panel
@onready var cost: Label = $Visuals/Cost
@onready var icon: TextureRect = $Visuals/Icon


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
		
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		popup_requested.emit(card)


func _on_visuals_mouse_entered() -> void:
	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)


func _on_visuals_mouse_exited() -> void:
	panel.set("theme_override_styles/panel", BASE_STYLEBOX)
