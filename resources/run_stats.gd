class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 70

@export var gold := STARTING_GOLD : set = set_gold


func set_gold(value: int) -> void:
	gold = value
	gold_changed.emit()
