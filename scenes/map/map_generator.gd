class_name MapGenerator
extends Node

const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MIDDLE_FLOOR_INDEX := floori(FLOORS * 0.5)
const MAP_WIDTH := 7
const MIDDLE_ROOM_INDEX := floori(MAP_WIDTH * 0.5)
const PATHS := 6
const BATTLE_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0

var random_room_type_weights := {
	Room.Type.BATTLE: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0
}
var random_room_type_total_weight := 0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for col in starting_points:
		var current_col := col
		for row in FLOORS - 1:
			current_col = _setup_connections(row, current_col)
			
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data
	
	
func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for row in FLOORS:
		var new_floor: Array[Room] = []
		
		for col in MAP_WIDTH:
			var new_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			new_room.row = row
			new_room.column = col
			new_room.position = Vector2(col * X_DIST, row * -Y_DIST) + floor(offset)
			new_room.next_rooms = []
			
			# Boss room has non-random y
			if row == FLOORS - 1:
				new_room.position.y = (row + 1) * -Y_DIST
			
			new_floor.append(new_room)
			
		result.append(new_floor)
			
	return result
	
	
func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
				
			y_coordinates.append(starting_point)

	return y_coordinates
	
	
func _setup_connections(row: int, col: int) -> int:
	var next_room: Room
	var current_room := map_data[row][col] as Room
	
	while not next_room or _would_cross_existing_path(row, col, next_room):
		var random_col := clampi(randi_range(col - 1, col + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[row + 1][random_col]
		
	current_room.next_rooms.append(next_room)
	return next_room.column
	
	
func _would_cross_existing_path(row: int, col: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room
	
	# if col == 0, no left neighbour possible
	if col > 0:
		left_neighbour = map_data[row][col - 1]
	# if col == MAP_WIDTH - 1, no right neighbour possible
	if col < MAP_WIDTH - 1:
		right_neighbour = map_data[row][col + 1]
		
	# Can't cross in right dir if right neighbour goes to left
	if right_neighbour and room.column > col:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
				
	# Can't cross in left dir if left neighbour goes to right
	if left_neighbour and room.column < col:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true
		
	return false
	
	
func _setup_boss_room() -> void:
	var boss_room := map_data[FLOORS - 1][MIDDLE_ROOM_INDEX] as Room
	
	for col in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][col] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
			
	boss_room.type = Room.Type.BOSS
	
	
func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.BATTLE] = BATTLE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = BATTLE_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = BATTLE_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	random_room_type_total_weight = random_room_type_weights[Room.Type.SHOP]
	
	
func _setup_room_types() -> void:
	# First floor rooms are always battles
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.BATTLE
			
	# 9th floor rooms are always treasures
	for room: Room in map_data[MIDDLE_FLOOR_INDEX]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.TREASURE
			
	# Last floor rooms are always campfires
	for room: Room in map_data[FLOORS - 2]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.CAMPFIRE
		
	for floor in map_data:
		for room: Room in floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)
					
					
func _set_room_randomly(room_to_set: Room) -> void:
	var campfire_below_floor_4 := true
	var consecutive_campfires := true
	var consecutive_shops := true
	var campfire_on_last_floor := true
	
	var type_candidate: Room.Type
	
	while campfire_below_floor_4 or consecutive_campfires or consecutive_shops or campfire_on_last_floor:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)
		
		campfire_below_floor_4 = is_campfire and room_to_set.row < 3
		consecutive_campfires = is_campfire and has_campfire_parent
		consecutive_shops = is_shop and has_shop_parent
		campfire_on_last_floor = is_campfire and room_to_set.row == FLOORS - 2
				
	room_to_set.type = type_candidate
	
	
func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
			
	return Room.Type.BATTLE
	
	
func _room_has_parent_of_type(room: Room, target_type: Room.Type) -> bool:
	var parents: Array[Room] = []
	
	# Left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
			
	# Below parent
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
			
	# Right parent
	if room.column < MAP_WIDTH - 1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
			
	for parent: Room in parents:
		if parent.type == target_type:
			return true
	
	return false
