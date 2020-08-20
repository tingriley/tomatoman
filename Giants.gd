extends Node2D

var children = 2


func _ready():
	pass # Replace with function body.


func get_num_childern():
	return children

func _process(delta):
	var count = 0
	var ch = get_children()
	for c in ch:
		if "Snow" in c.name:
			count += 1
	children = count
