class_name CardPopUp
extends Control

const CARD_MENU_UI_SCENE := preload("res://scenes/ui/card_menu_ui.tscn")

@export var bg_color: Color = Color("00000090")

@onready var background: ColorRect = $Background
@onready var pop_up_card: CenterContainer = %PopUpCard
@onready var card_title: Label = %CardTitle
@onready var card_description: RichTextLabel = %CardDescription


func _ready() -> void:
	for card: CardMenuUI in pop_up_card.get_children():
		card.queue_free()
		
	background.color = bg_color


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		hide_popup()
	

func show_popup(card: Card) -> void:
	var new_card := CARD_MENU_UI_SCENE.instantiate()
	
	pop_up_card.add_child(new_card)
	new_card.card = card
	new_card.popup_requested.connect(hide_popup.unbind(1))
	card_title.text = card.name
	card_description.text = card.tooltip_text
	show()

	
func hide_popup() -> void:
	if not visible:
		return
		
	for card: CardMenuUI in pop_up_card.get_children():
		card.queue_free()
		
	hide()
