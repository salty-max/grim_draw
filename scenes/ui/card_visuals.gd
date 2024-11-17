class_name CardVisuals
extends Control

const BASE_STYLEBOX := preload("res://scenes/ui/card_base_stylebox.tres")

@export var card: Card : set = set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	set_stylebox(BASE_STYLEBOX)
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = Card.RARITY_COLORS[card.rarity]
	
	
func set_stylebox(_stylebox: StyleBoxFlat) -> void:
	var stylebox = _stylebox.duplicate()
	stylebox.set("bg_color", card.get_archetype_color())
	panel.set("theme_override_styles/panel", stylebox)	
