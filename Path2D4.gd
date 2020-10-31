extends Path2D

onready var follow = get_node("Follow")
func _ready():
	pass

func _process(delta):
	follow.offset = (follow.offset + 200*delta)


