class_name Status
extends Resource

signal status_applied(status: Status)
signal status_changed

enum Type {
	START_OF_TURN,
	END_OF_TURN,
	EVENT_BASED
}

enum StackType {
	NONE,
	INTENSITY,
	DURATION,
	COMPOSITE
}

@export_group("Status Data")
@export var id: String
@export var type: Type
@export var stack_type: StackType
@export var can_expire: bool
@export var duration: int : set = set_duration
@export var stacks: int : set = set_stacks

@export_group("Status Visuals")
@export var icon: Texture
@export_multiline var description: String


func initialize_status(_target: Node) -> void:
	pass
	
	
func apply_status(_target: Node) -> void:
	status_applied.emit(self)
	
	
func get_description() -> String:
	return description


func set_duration(value: int) -> void:
	duration = value
	status_changed.emit()
	
	
func set_stacks(value: int) -> void:
	stacks = value
	status_changed.emit()
