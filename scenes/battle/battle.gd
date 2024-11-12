extends Node2D

@export var char_stats: CharacterStats
@export var music_track: AudioStream

@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var battle_ui: BattleUI = $BattleUI
@onready var player: Player = $Player



func _ready() -> void:
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemies_turn_ended.connect(_on_enemies_turn_ended)
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)
	
	
func start_battle(stats: CharacterStats) -> void:
	MusicPlayer.play(music_track, true)
	enemy_handler.reset_enemies_action()
	player_handler.start_battle(stats)
	
	
func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		print("Victory!")	
	
	
func _on_enemies_turn_ended() -> void:
	enemy_handler.reset_enemies_action()
	player_handler.start_turn()
	
	
func _on_player_died() -> void:
	print("Game over!")
