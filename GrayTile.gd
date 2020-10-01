extends StaticBody2D

var speed = 0
func _ready():
	pass # Replace with function body.




func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		$AnimatedSprite.play("diminish")
		yield(get_tree().create_timer(0.1), "timeout")
		speed = 200
		yield(get_tree().create_timer(1), "timeout")
		queue_free()

func _physics_process(delta):
	position.y += speed*delta
