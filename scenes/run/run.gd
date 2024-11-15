class_name Run
extends Node

const BATTLE_SCENE = preload("res://scenes/battle/battle.tscn")
const CAMPFIRE_SCENE = preload("res://scenes/campfire/campfire.tscn")
const MAP_SCENE = preload("res://scenes/map/map.tscn")
const REWARDS_SCENE = preload("res://scenes/rewards/rewards.tscn")
const SHOP_SCENE = preload("res://scenes/shop/shop.tscn")
const TREASURE_ROOM_SCENE = preload("res://scenes/treasure_room/treasure_room.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView
@onready var debug_buttons: MarginContainer = $DebugButtons
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton
@onready var treasure_room_button: Button = %TreasureRoomButton

var character: CharacterStats


func _ready() -> void:		
	if not run_startup:
		return
	print(run_startup.picked_character)
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
	_setup_event_connections()
	print("TODO: procedurally generate map")
	
	
func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	
	
func _setup_event_connections() -> void:
	Events.battle_won.connect(_change_view.bind(REWARDS_SCENE))
	Events.rewards_exited.connect(_change_view.bind(MAP_SCENE))
	Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	rewards_button.pressed.connect(_change_view.bind(REWARDS_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_room_button.pressed.connect(_change_view.bind(TREASURE_ROOM_SCENE))
	
	
func _on_map_exited() -> void:
	pass