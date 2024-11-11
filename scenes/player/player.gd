class_name Player extends Node2D

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI


func _ready() -> void:
	sprite_2d.play("default")
	

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()	
		

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready

	sprite_2d.sprite_frames = stats.art
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)
	
	
func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
		
	stats.take_damage(damage)
	
	if stats.health <= 0:
		sprite_2d.play("death")
		await sprite_2d.animation_finished
		Events.player_died.emit()
		queue_free()
