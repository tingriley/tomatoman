extends Area2D

var start = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")




func _on_Spike_body_entered(body):
	if "Player" in body.name:
		body.dead()
		body.is_on_spike = true
		


func _on_Spike_body_exited(body):
	if "Player" in body.name:
		body.is_on_spike = false
