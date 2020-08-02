extends Area2D

onready var global = get_node("/root/Global")
const DIALOGBOX = preload("DialogBox.tscn")
var velocity = Vector2(0, 100)
var start = false

func load_dialog_box(body):
	body.get_node("CanvasLayer/DialogBox").visible = true
	body.get_node("CanvasLayer/DialogBox/DialogBox").dialog[0] = '\n\t\t\tYou found a key. (Press DOWN to continue)'
	body.get_node("CanvasLayer/DialogBox/DialogBox").load_dialog()


func _ready():
	$AnimatedSprite.play("idle")

func start():
	start = true
	
func _physics_process(delta):
	if position.y <= 660 and start:
		translate(velocity*delta)
		velocity.y += 2
	

func _on_BlueKey_body_entered(body):
	if "Player" in body.name:
		
		global.blue_key_found = true
		if not body.is_powerup:
			body.is_powerup = true
			visible = false
			yield(get_tree().create_timer(2.0), "timeout")
			get_parent().get_node("Shake").screen_shake(1, 15, 100)
			get_parent().get_node("Block2").queue_free()
			get_parent().get_node("Block3").queue_free()
			body.is_powerup = false
			queue_free()
