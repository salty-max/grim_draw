extends Node

@warning_ignore("unused_signal")

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)

# Tooltip-related events
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

# Player-related events
signal player_card_draw_requested(amount: int)
signal player_card_discard_requested(amount: int)
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

# Enemy-related events
signal enemy_action_completed(enemy: Enemy)
signal enemies_turn_ended
signal enemy_died(enemy: Enemy)

# Battle-related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won

# Map-related events
signal map_exited(room: Room)

# Shop-related events
signal shop_exited

# Campfire-related events
signal campfire_exited

# Rewards-related events
signal rewards_exited

# TreasureRoom-related events
signal treasure_room_exited
