@tool
extends Node3D

# Now you just type "beanshooter" or "sunflower" in the inspector!
@export var tower_name_id: String = "":
	set(value):
		tower_name_id = value
		# Only update if we are inside the editor or running the game
		if is_inside_tree() or Engine.is_editor_hint():
			_update_sprite()

func _ready():
	print("DEBUG: Tower 3D Ready. Current ID: ", tower_name_id)
	_update_sprite()

func setup_tower(tower_2d_scene: PackedScene):
	var viewport = $SubViewport
	for child in viewport.get_children():
		child.free()
		
	var tower_instance = tower_2d_scene.instantiate()
	viewport.add_child(tower_instance)


func _update_sprite():
	print("DEBUG: Update Sprite called. ID is: '", tower_name_id, "'")
	
	if tower_name_id == "": 
		print("DEBUG: ID is empty. Stopping.")
		return
	
	var sprite_path = "res://scenes/towers/" + tower_name_id + "/" + tower_name_id + "_sprite.tscn"
	print("DEBUG: Loading sprite from: ", sprite_path)
	
	var sprite_scene = load(sprite_path)
	
	if sprite_scene:
		var viewport = $SubViewport
		var sprite_3d = $Sprite3D
		
		# Clear old sprites
		for child in viewport.get_children():
			child.free()
			
		# Instance the 2D logic
		var tower_instance = sprite_scene.instantiate()
		viewport.add_child(tower_instance)
		print("DEBUG: 2D Sprite added to Viewport.")

		# --- FIX 2: FORCE THE TEXTURE ---
		# We force the texture to update immediately
		var tex = viewport.get_texture()
		sprite_3d.texture = tex
		print("DEBUG: Texture assigned to Sprite3D: ", tex)
		# --------------------------------
		
	else:
		push_error("Tower Anchor: Could not find sprite at " + sprite_path)
