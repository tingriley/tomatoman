extends Area2D

onready var global = get_node("/root/Global")
var play_open_animation = false

func _ready():
	$KinematicBody2D/AnimatedSprite.play("idle")



func _on_GreenLock_body_entered(body):
	if "Player" in body.name:
		print(body.name)
		if global.green_key_found:
			global.green_lock_open = true
			$KinematicBody2D/AnimatedSprite.play("open")
			yield(get_tree().create_timer(1), "timeout")
			queue_free()
