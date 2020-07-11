extends Camera2D
onready var global = get_node("/root/Global")

var playerTarget

func _ready():
	playerTarget = get_parent()

func _process(delta):
	pass
	global_position = playerTarget.global_position
	
	
