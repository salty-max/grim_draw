class_name CharacterSelector
extends Control

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const WARRIOR_STATS = preload("res://characters/warrior/warrior.tres")
const ROGUE_STATS = preload("res://characters/rogue/rogue.tres")
const MAGE_STATS = preload("res://characters/mage/mage.tres")

@export var run_startup: RunStartup

@onready var class_title: Label = %ClassTitle
@onready var class_description: Label = %ClassDescription
@onready var warrior_sprite: AnimatedSprite2D = %WarriorSprite
@onready var rogue_sprite: AnimatedSprite2D = %RogueSprite
@onready var mage_sprite: AnimatedSprite2D = %MageSprite

var current_character: CharacterStats : set = set_current_character
var current_sprite: AnimatedSprite2D

func _ready() -> void:
	set_current_character(WARRIOR_STATS)
	

func _process(delta: float) -> void:
	current_sprite.play("default")
	
	
func set_current_character(stats: CharacterStats) -> void:
	current_character = stats
	class_title.text = current_character.name
	class_description.text = current_character.description
	
	if current_sprite:
		current_sprite.stop()
	
	match current_character.name:
		"Warrior":
			current_sprite = warrior_sprite
		"Rogue":
			current_sprite = rogue_sprite
		"Mage":
			current_sprite = mage_sprite


func _on_start_run_button_pressed() -> void:
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR_STATS


func _on_rogue_button_pressed() -> void:
	current_character = ROGUE_STATS


func _on_mage_button_pressed() -> void:
	current_character = MAGE_STATS
