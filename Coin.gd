extends Area2D

onready var global = get_node("/root/Global")

func _ready():
	$AnimatedSprite.play("spin")



func _on_Coin_body_entered(body):
	if "Player" in body.name:
		global.score += 10
		global.coin += 1 
		queue_free()
