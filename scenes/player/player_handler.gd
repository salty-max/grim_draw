class_name PlayerHandler extends Node

const HAND_DRAW_INTERVAL := 0.15
const HAND_DISCARD_INTERVAL := 0.15

@export var hand: Hand

var character: CharacterStats


func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	Events.player_card_draw_requested.connect(_on_card_draw_requested)
	Events.player_card_discard_requested.connect(_on_card_discard_requested)


func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard_pile = CardPile.new()
	start_turn()
	
	
func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	draw_cards(character.cards_per_turn)
	
	
func end_turn() -> void:
	hand.disable_hand()
	discard_cards()
	
	
func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()
	
	
func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
		
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)
	
	
func discard_cards() -> void:
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(character.discard_pile.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
		
	tween.finished.connect(
		func(): Events.player_hand_discarded.emit()
	)
	
func discard_n_cards(amount: int) -> void:
	var tween := create_tween()
	var hand_card_uis := hand.get_children()
	hand_card_uis.shuffle()
	var selected_cards := hand_card_uis.slice(0, amount)
	for card_ui in selected_cards:
		tween.tween_callback(character.discard_pile.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	
func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.is_empty():
		return
		
	while not character.discard_pile.is_empty():
		character.draw_pile.add_card(character.discard_pile.draw_card())
		
	character.draw_pile.shuffle()
		
		
func _on_card_played(card: Card) -> void:
	character.discard_pile.add_card(card)
	
	
func _on_card_draw_requested(amount: int) -> void:
	draw_cards(amount)
	
	
func _on_card_discard_requested(amount: int) -> void:
	discard_n_cards(amount)
