class_name Card extends Resource

enum Type {
	ATTACK,
	SKILL,
	POWER
}

enum Target {
	SELF,
	SINGLE_ENEMY,
	ALL_ENEMIES,
	BOARD
}

enum Archetype {
	BASIC,
	WARRIOR,
	ROGUE,
	MAGE
}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE
}

const RARITY_COLORS := {
	Rarity.COMMON: Color.GRAY,
	Rarity.UNCOMMON: Color.CORNFLOWER_BLUE,
	Rarity.RARE: Color.GOLD
}

@export_group("Card Attributes")
@export var id: String
@export var name: String
@export var type: Type
@export var target: Target
@export var archetype: Archetype
@export var rarity: Rarity
@export var cost: int
@export var exhausts: bool = false

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY
	

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
		
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.BOARD:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []
			
			
func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))
		
		
func apply_effects(_targets: Array[Node]) -> void:
	pass

	
func get_archetype_color() -> Color:
	var color: Color
	
	match archetype:
		Archetype.WARRIOR:
			color = Color("#a15952")
		Archetype.ROGUE:
			color = Color("#3d8157")
		Archetype.MAGE:
			color = Color("#32799a")
		Archetype.BASIC:
			color = Color("#888888")
			
	return color
