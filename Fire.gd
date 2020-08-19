extends Area2D




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("off")




func _on_Timer_timeout():
	$AnimatedSprite.play("off")
	visible = false
	yield(get_tree().create_timer(1), "timeout")
	$AnimatedSprite.play("idle")
	visible = true


func _on_Fire_body_entered(body):
	if "Player" in body.name:
		if visible:
			body.dead()
