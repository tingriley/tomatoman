extends Area2D

onready var global = get_node("/root/Global")
const DIALOGBOX = preload("DialogBox.tscn")


func load_dialog_box(body):
	body.get_node("CanvasLayer/DialogBox/").visible = true
	body.get_node("CanvasLayer/DialogBox/DialogBox").dialog[0] = '\n\t\t\tYou found a key. (Press DOWN to continue)'
	body.get_node("CanvasLayer/DialogBox/DialogBox").load_dialog()



func _ready():
	$AnimatedSprite.play("idle")



func _on_GreenKey_body_entered(body):
	if "Player" in body.name:
		load_dialog_box(body)
		global.green_key_found = true
		if not body.is_powerup:
			body.is_powerup = true
			visible = false
			yield(get_tree().create_timer(2.0), "timeout")
			body.is_powerup = false
			queue_free()
