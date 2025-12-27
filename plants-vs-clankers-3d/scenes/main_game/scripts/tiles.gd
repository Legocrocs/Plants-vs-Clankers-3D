@tool
extends Node3D

@export var tile_atlas_coords : Vector2i = Vector2i(0, 0):
	set(value):
		tile_atlas_coords = value
		_update_visuals()

@export var grid_position : Vector2i = Vector2i(0, 0)

var is_occupied : bool = false
var occupant = null
var is_hovered : bool = false  

func _ready() -> void:
	_update_visuals()
	add_to_group("tiles")
	
	if not Engine.is_editor_hint():
		_setup_collision()
		
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_hovered and can_occupy():
			_place_test_tower()

# tiles.gd

func _place_test_tower():
	print("DEBUG: Spawning tower...")
	var tower_scene = load("res://scenes/towers/tower_3D.tscn")
	var new_tower = tower_scene.instantiate()
	
	# 1. Give it a name (so the sprite loads)
	new_tower.tower_name_id = "beanshooter"
	
	# 2. Add it to the scene
	get_parent().add_child(new_tower)
	
	occupy(new_tower)
	print("DEBUG: Tower placed at ", new_tower.position)	
		
func _setup_collision():
	var static_body = StaticBody3D.new()
	static_body.name = "ClickableArea"
	add_child(static_body)
	
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(1, 0.1, 1) 
	collision_shape.shape = box_shape
	static_body.add_child(collision_shape)
	
	static_body.input_ray_pickable = true

func _process(delta: float) -> void:
	pass

func _update_visuals():
	var tiles_2d_scene = $SubViewport/TilesSprite
	
	if tiles_2d_scene:
		var tm = tiles_2d_scene.get_node("TileMapLayer")
		if tm:
			tm.clear()
			tm.set_cell(Vector2i(0, 0), 0, tile_atlas_coords)

func can_occupy() -> bool:
	return not is_occupied

func occupy(entity) -> bool:
	if can_occupy():
		is_occupied = true
		occupant = entity
		if entity is Node3D:
			entity.global_position = global_position
		return true
	return false

func vacate():
	is_occupied = false
	occupant = null

func get_occupant():
	return occupant

func set_hovered(hovered: bool):
	is_hovered = hovered
	var tiles_2d = $SubViewport/TilesSprite
	
	if tiles_2d:
		if is_hovered:
			tiles_2d.modulate = Color(1.5, 1.5, 1.5) 
		else:
			tiles_2d.modulate = Color(1, 1, 1) 
