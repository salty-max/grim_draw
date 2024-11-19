class_name Stats extends Resource

signal stats_changed

const MAX_BLOCK := 999

@export_group("Meta Data")
@export var name: String
@export var description: String

@export_group("Visuals")
@export var art: SpriteFrames

@export_group("Gameplay Data")
@export var max_health := 1


var health: int: set = set_health
var block: int :set = set_block


func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()
	
	
func set_block(value: int) -> void:
	block = clampi(value, 0, MAX_BLOCK)
	stats_changed.emit()
	
	
func take_damage(damage: int) -> void:
	if damage <= 0:
		return
		
	var initial_damage := damage
	damage = clampi(damage - block, 0, damage)
	block = clampi(block - initial_damage, 0, block)
	health -= damage
	
	
func heal(amount: int) -> void:
	health += amount
	
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	return instance
