extends Node2D

func _ready():
	pass

func _process(delta):
	get_parent().get_node("Player").is_on_ladder = is_on_ladder()
	get_parent().get_node("Player").can_climb_down = can_climb_down()


func can_climb_down():
	for child in get_children():
		if "Top" in child.name:
			if child.can_climb_down():
				return true
	return false

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
		
