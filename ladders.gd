extends Node2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	get_parent().get_node("Player").is_on_ladder = is_on_ladder()


func is_on_ladder():
	for child in get_children():
		if child.is_on_ladder:
			return true
	return false

func disable_collision():
	for child in get_children():
		child.set_collision_mask_bit(1, false)

func enable_collision():
	for child in get_children():
		child.set_collision_mask_bit(1, true)
		
