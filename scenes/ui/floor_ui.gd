class_name FloorUI
extends Label

@export var run_stats: RunStats : set = set_run_stats

func _ready():
	text = "Floor 0"
	
	
func set_run_stats(value: RunStats) -> void:
	run_stats = value
	
	if not run_stats.floor_changed.is_connected(_update_floor):
		run_stats.floor_changed.connect(_update_floor)
		_update_floor()
		
		
func _update_floor() -> void:
	text = "Floor %s" % str(run_stats.current_floor)
