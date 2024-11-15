class_name MainMenu
extends Control

const CHAR_SELECTOR_SCENE = preload("res://scenes/ui/character_selector.tscn")

@export var music: AudioStream

@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	MusicPlayer.play(music, true)
	for child in get_children():
		if child is AnimatedSprite2D:
			child.play("default")


func _on_continue_button_pressed() -> void:
	print("Continue")


func _on_new_game_button_pressed() -> void:
	# TODO: Smoother transition between scenes
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
