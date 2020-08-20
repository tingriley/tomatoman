extends Area2D

onready var global = get_node("/root/Global")

var is_used = false

func _ready():
	pass # Replace with function body.



func _on_Tomato_body_entered(body):
	if "Player" in body.name:
		if not is_used:
			global.hp = min(global.hp + 2, global.HP_MAX)
			$AnimatedSprite.play("used")
			is_used = true


