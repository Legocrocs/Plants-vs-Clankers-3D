extends Node3D
class_name GridManager

var tiles = {}
var camera : Camera3D
var hovered_tile = null

func _ready():
	call_deferred("_register_tiles")
	camera = get_viewport().get_camera_3d()

func _register_tiles():
	for tile in get_tree().get_nodes_in_group("tiles"):
		if tile.has_method("can_occupy"):
			tiles[tile.grid_position] = tile
	
	print("GridManager: Registered ", tiles.size(), " tiles")

func _input(event):
	if event is InputEventMouseMotion:
		_handle_mouse_hover(event.position)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_click()

func _handle_mouse_hover(mouse_pos: Vector2):
	if not camera:
		return
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if hovered_tile and hovered_tile.has_method("set_hovered"):
		hovered_tile.set_hovered(false)
	hovered_tile = null
	
	# this is to check if we clicked on a tile or not
	if result:
		var hit_node = result.collider
		if hit_node.get_parent().is_in_group("tiles"):
			hovered_tile = hit_node.get_parent()
			if hovered_tile.has_method("set_hovered"):
				hovered_tile.set_hovered(true)

#debuggin time
func _handle_click():
	if hovered_tile:
		print("Clicked tile at: Lane ", hovered_tile.grid_position.x, 
			  ", Column ", hovered_tile.grid_position.y)
		
		# creating a test cube on the tile since we have no plant scene yet
		if hovered_tile.can_occupy():
			var test_cube = MeshInstance3D.new()
			test_cube.mesh = BoxMesh.new()
			var material = StandardMaterial3D.new()
			material.albedo_color = Color(0.2, 0.8, 0.2)
			test_cube.mesh.material = material
			add_child(test_cube)
			
			place_entity(hovered_tile.grid_position.x, 
						hovered_tile.grid_position.y, test_cube)
		else:
			print("Tile is already occupied!")

func get_tile_at(lane: int, column: int):
	return tiles.get(Vector2i(lane, column))

func can_place_at(lane: int, column: int) -> bool:
	var tile = get_tile_at(lane, column)
	return tile != null and tile.can_occupy()

func place_entity(lane: int, column: int, entity) -> bool:
	var tile = get_tile_at(lane, column)
	if tile and tile.occupy(entity):
		print("Placed on Lane ", lane, ", Column ", column)
		return true
	print("Cant place at Lane ", lane, ", Column ", column)
	return false

func remove_entity(lane: int, column: int):
	var tile = get_tile_at(lane, column)
	if tile:
		tile.vacate()

func get_lane_tiles(lane: int) -> Array:
	var lane_tiles = []
	for pos in tiles.keys():
		if pos.x == lane:
			lane_tiles.append(tiles[pos])
	return lane_tiles

func is_lane_blocked(lane: int) -> bool:
	for tile in get_lane_tiles(lane):
		if tile.is_occupied:
			return true
	return false
