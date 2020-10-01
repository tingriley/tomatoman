extends Node2D


const GREENBALL = preload("GreenBall.tscn")
export var delay = 0.0


func _ready():
	$AnimatedSprite.play("idle")


func shoot():
	var ball = null
	ball = GREENBALL.instance()
	ball.set_speed(Vector2(0, 100))
	get_parent().add_child(ball)
	ball.position = $Position2D.global_position + Vector2(0, 64)


func animate_and_fire():
	$AnimatedSprite.play("fire")
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimatedSprite.play("idle")
	shoot()




func _on_Timer_timeout():
	animate_and_fire()
