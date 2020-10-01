extends Node2D


func _ready():
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		$AudioStreamPlayer2D.stop()
		get_tree().change_scene("res://Stage8.tscn")	



