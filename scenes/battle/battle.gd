class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats
@export var music_track: AudioStream

@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var battle_ui: BattleUI = $BattleUI
@onready var player: Player = $Player



func _ready() -> void:
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemies_turn_ended.connect(_on_enemies_turn_ended)
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	
func start_battle() -> void:
	MusicPlayer.play(music_track, true)
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemies_action()
	player_handler.start_battle(char_stats)
	battle_ui.initialize_card_pile_ui()
	
	
func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("You survive... for now!", BattleOverPanel.Type.WIN)
	
	
func _on_enemies_turn_ended() -> void:
	enemy_handler.reset_enemies_action()
	player_handler.start_turn()
	
	
func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Your journey ends here...", BattleOverPanel.Type.LOSE)
