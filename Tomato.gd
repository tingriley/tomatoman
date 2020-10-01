extends Area2D

onready var global = get_node("/root/Global")

var is_used = false

func _ready():
	pass # Replace with function body.



func _on_Tomato_body_entered(body):
	if "Player" in body.name:
		
		if not is_used:
			$AudioStreamPlayer2D.play()
			is_used = true

			visible = false
			body.get_node("CanvasLayer/Control/RichTextLabel").set_code(3)
			body.get_node("CanvasLayer/Control/Timer").start()
			yield(get_tree().create_timer(1.0), "timeout")
			global.HP_MAX += 2
			global.hp += 2
			$AnimatedSprite.play("used")
			yield(get_tree().create_timer(1.0), "timeout")
			queue_free()
			


