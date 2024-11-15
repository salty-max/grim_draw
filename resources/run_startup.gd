class_name RunStartup
extends Resource

enum Type {
	NEW_RUN,
	ONGOING_RUN
}

@export var type: Type
@export var picked_character: CharacterStats
