extends StaticBody2D

var is_on_ladder = false

func _ready():
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		is_on_ladder = true


func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		is_on_ladder = false
