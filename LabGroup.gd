extends Node2D


var children
var max_child
var dir = 1
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	children = get_children()
	max_child = len(children)
	print(max_child)

func animate_children():
	if max_child > 1:
		children[count].animate_and_fire()
		count += dir
		if(count == max_child-1):
			dir *= -1
		if(count == 0):
			dir *= -1
		yield(get_tree().create_timer(0.5), "timeout")

	else:
		children[0].animate_and_fire()


func animate_children_right():

	children[count].animate_and_fire()
	count += dir
	yield(get_tree().create_timer(0.5), "timeout")
	if(count == max_child):
		count = 0


