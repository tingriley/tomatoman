extends Node2D
onready var global = get_node("/root/Global")

var is_playing = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play():
	if not is_playing:
		$AudioStreamPlayer2D.play()
		is_playing = true


