@tool
extends Node3D

# Now you just type "beanshooter" or "sunflower" in the inspector!
@export var tower_name_id: String = "":
	set(value):
		tower_name_id = value
		if Engine.is_editor_hint():
			_update_sprite()

func _ready():
	_update_sprite()

func setup_tower(tower_2d_scene: PackedScene):
	var viewport = $SubViewport
	for child in viewport.get_children():
		child.free()
		
	var tower_instance = tower_2d_scene.instantiate()
	viewport.add_child(tower_instance)


func _update_sprite():
	if tower_name_id == "": return
	
	# Automatically finds res://scenes/towers/beanshooter/beanshooter_sprite.tscn
	var sprite_path = "res://scenes/towers/" + tower_name_id + "/" + tower_name_id + "_sprite.tscn"
	var sprite_scene = load(sprite_path)
	
	if sprite_scene:
		var viewport = $SubViewport
		# Clear old sprites
		for child in viewport.get_children():
			child.free()
			
		# Instance the 2D logic/animation scene
		var tower_instance = sprite_scene.instantiate()
		viewport.add_child(tower_instance)
	else:
		push_error("Tower Anchor: Could not find sprite at " + sprite_path)
