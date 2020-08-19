extends StaticBody2D

var is_on_ladder= false

func _ready():
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		is_on_ladder = true


func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		is_on_ladder = false

func can_climb_down():
	var collider = $RayCast2D.get_collider()

	if collider and "Player" in collider.name:
		return true
	
	return false
	


