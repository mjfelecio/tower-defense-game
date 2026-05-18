extends Node2D

const VALID_TILE_COLOR = "ad54ff3c"
const INVALID_TILE_COLOR = "red"

var map_node: Node2D

var build_mode = false
var build_valid = false
var build_location: Vector2
var build_type: String # Should prob be enum later

func _ready() -> void:
	map_node = get_node("Map1")

	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", initiate_build_mode.bind(i.get_name().to_lower()))

func _process(delta: float) -> void:
	if build_mode:
		update_tower_preview()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()

	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func initiate_build_mode(tower_type: String) -> void:
	# If the new tower type is the same anyways, just return
	# else we allow to pass for switching towers
	if build_mode and tower_type == build_type.split("_")[0]: # we remove the tier info
		return
	
	build_type = tower_type + "_t1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview() -> void:
	var tower_exclusion_layer: TileMapLayer = map_node.get_node("TowerExclusion")
	
	var mouse_pos = get_global_mouse_position()
	var current_tile: Vector2i = tower_exclusion_layer.local_to_map(mouse_pos)
	var tile_pos: Vector2 = tower_exclusion_layer.map_to_local(current_tile)

	# TODO: Check if the tile is already occupied by an existing tower as well
	var is_valid_tile = tower_exclusion_layer.get_cell_tile_data(current_tile) == null

	if is_valid_tile:
		get_node("UI").update_tower_preview(tile_pos, VALID_TILE_COLOR)
		build_valid = true
		build_location = tile_pos
	else:
		get_node("UI").update_tower_preview(tile_pos, INVALID_TILE_COLOR)
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").queue_free()

func verify_and_build():
	if build_valid:
		# todo: check if has enough cash before this
		var new_tower = load("res://scenes/turrets/" + build_type + ".tscn").instantiate()
		
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
		
		## todo: deduct cash and update cash label
		
