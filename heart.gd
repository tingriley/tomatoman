extends Area2D

onready var global = get_node("/root/Global")

var enter = false
func _ready():
	$AnimatedSprite.play("idle")
	


func _on_gun_body_entered(body):
	print (body.name)
	if "Player" in body.name:
		if not enter:
			enter = true
			global.hp = global.HP_MAX
			if not $AudioStreamPlayer2D.playing:
				$AudioStreamPlayer2D.play()
			visible = false
			body.get_node("CanvasLayer/Control/RichTextLabel").set_code(3)
			body.get_node("CanvasLayer/Control/Timer").start()
			yield(get_tree().create_timer(1.0), "timeout")
			queue_free()
