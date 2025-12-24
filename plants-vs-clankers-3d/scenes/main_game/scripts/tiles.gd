@tool
extends Node3D

@export var tile_atlas_coords : Vector2i = Vector2i(0, 0):
	set(value):
		tile_atlas_coords = value
		_update_visuals()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_visuals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_visuals():
	var tiles_2d_scene = $SubViewport/TilesSprite
	
	# Check if the node exists to avoid errors
	if tiles_2d_scene:
		# Search for the TileMapLayer inside that instanced scene
		var tm = tiles_2d_scene.get_node("TileMapLayer")
		if tm:
			tm.clear()
			# Places the specific tile at 0,0
			tm.set_cell(Vector2i(0, 0), 0, tile_atlas_coords)
