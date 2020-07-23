extends Area2D

var is_on_ladder = false

func _ready():
	pass # Replace with function body.



func _on_Ladder_body_entered(body):
	if "Player" in body.name:
		get_parent().get_node("Player").is_on_ladder = true


func _on_Ladder_body_exited(body):
	if "Player" in body.name:
		get_parent().get_node("Player").is_on_ladder = false
