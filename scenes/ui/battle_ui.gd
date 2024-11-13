class_name BattleUI extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand: Hand = $Hand
@onready var mana_ui: ManaUI = $ManaUI
@onready var end_turn_button: Button = %EndTurnButton


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	Events.battle_over_screen_requested.connect(_on_battle_over_screen_requested)


func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	hand.char_stats = char_stats
	mana_ui.char_stats = char_stats
	
	
func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false
	

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
	
	
func _on_battle_over_screen_requested(_text: String, _type: BattleOverPanel.Type) -> void:
	print("coucou")
	hide()
	
