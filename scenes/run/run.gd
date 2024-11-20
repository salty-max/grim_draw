class_name Run
extends Node

const BATTLE_SCENE = preload("res://scenes/battle/battle.tscn")
const CAMPFIRE_SCENE = preload("res://scenes/campfire/campfire.tscn")
const BATTLE_REWARDS_SCENE = preload("res://scenes/battle_rewards/battle_rewards.tscn")
const SHOP_SCENE = preload("res://scenes/shop/shop.tscn")
const TREASURE_ROOM_SCENE = preload("res://scenes/treasure_room/treasure_room.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var health_ui: HealthUI = %HealthUI
@onready var gold_ui: GoldUI = %GoldUI
@onready var floor_ui: FloorUI = %FloorUI
@onready var map: Map = $Map
# TODO: Remove debug buttons
@onready var debug_buttons: MarginContainer = $DebugLayer/DebugButtons
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton
@onready var treasure_room_button: Button = %TreasureRoomButton

var character: CharacterStats
var stats: RunStats


func _ready() -> void:		
	if not run_startup:
		return
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.ONGOING_RUN:
			print("TODO: load previous run")
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		debug_buttons.hide() if debug_buttons.visible else debug_buttons.show()
		
		
func _start_run() -> void:
	stats = RunStats.new()
	stats.current_floor = map.floors_climbed
	_setup_event_connections()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)
	
	
func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view
	
	
func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	map.show_map()
	map.unlock_next_rooms()
	stats.current_floor = map.floors_climbed
	
func _setup_top_bar() -> void:
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character)
	gold_ui.run_stats = stats
	floor_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	
	
func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.rewards_exited.connect(_show_map)
	Events.campfire_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_room_button.pressed.connect(_change_view.bind(TREASURE_ROOM_SCENE))
	
	
func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.start_battle()	


func _on_campfire_room_entered() -> void:
	var campfire_scene: Campfire = _change_view(CAMPFIRE_SCENE) as Campfire
	campfire_scene.char_stats = character

	
func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARDS_SCENE) as BattleRewards
	
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	
	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()
	
	
func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.BATTLE:
			_on_battle_room_entered(room)
		Room.Type.BOSS:
			_on_battle_room_entered(room)
		Room.Type.CAMPFIRE:
			_on_campfire_room_entered()
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.TREASURE:
			_change_view(TREASURE_ROOM_SCENE)
