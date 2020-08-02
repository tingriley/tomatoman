extends Node2D


onready var global = get_node("/root/Global")
export(String, FILE, "*.tscn") var left_stage

func _ready():
	pass

func _process(delta):
	
	global.prev_stage = 10
	if $Player.position.x <= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().change_scene(left_stage)


