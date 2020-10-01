extends Area2D

onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")
	if global.double_jump:
		queue_free()



func _on_gun_body_entered(body):
	print (body.name)
	if "Player" in body.name:
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
		global.double_jump = true
		visible = false
		body.get_node("CanvasLayer/Control/RichTextLabel").set_code(4)
		body.get_node("CanvasLayer/Control/Timer").start()
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()