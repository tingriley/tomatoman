extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")

func _on_gun_body_entered(body):
	print (body.name)
	if "Player" in body.name:
		if not body.is_powerup:
			body.is_powerup = true
			visible = false
			yield(get_tree().create_timer(1.0), "timeout")
			body.is_powerup = false
			queue_free()
