extends Area2D

onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")


func load_dialog_box(body):
	body.get_node("CanvasLayer/DialogBox").visible = true
	body.get_node("CanvasLayer/DialogBox/DialogBox").dialog[0] = '\n\t\t\tYou found a gun. (Press DOWN to continue)'
	body.get_node("CanvasLayer/DialogBox/DialogBox").load_dialog()

func _on_gun_body_entered(body):
	print (body.name)
	if "Player" in body.name:
		load_dialog_box(body)
		if not body.is_powerup:
			body.is_powerup = true
			global.gun_found = true
			visible = false
			yield(get_tree().create_timer(1.0), "timeout")
			body.is_powerup = false
			queue_free()
