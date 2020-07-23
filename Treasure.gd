extends Area2D

onready var player_vars = get_node("/root/Global")

func _ready():
	$AnimatedSprite.play('close')

var player
var is_entered = false

func _on_Treasure_body_entered(body):
	if "Player" in body.name:
		$AnimatedSprite.play('open')
		player = body
		if not is_entered:
			body.set_is_back(true)
			is_entered = true
			#player_vars.score += 200
		$Timer.start()
		
func _on_Timer_timeout():
	player.set_is_back(false)
	$Timer.stop()
