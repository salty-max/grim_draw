class_name RewardButton
extends Button

@export var custom_icon: Texture : set = set_reward_icon
@export var custom_label: String : set = set_reward_label

@onready var reward_icon: TextureRect = %RewardIcon
@onready var reward_label: Label = %RewardLabel


func set_reward_icon(value: Texture) -> void:
	custom_icon = value
	
	if not is_node_ready():
		await ready
	
	reward_icon.texture = custom_icon
	
	
func set_reward_label(value: String) -> void:
	custom_label = value
	
	if not is_node_ready():
		await ready
		
	reward_label.text = custom_label
	
	
func _on_pressed() -> void:
	queue_free()
