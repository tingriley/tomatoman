extends KinematicBody2D
const BALL = preload("YellowBall.tscn")
var hp = 10
var is_dead = false
var direction = -1

func _ready():
	$AnimatedSprite.play("idle") 

func dead(damage):
	hp-=damage
	if hp <= 0:
		is_dead = true
		$AnimatedSprite.play("dead")
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()

func _process(delta):
	if is_dead:
		$AnimatedSprite.play("dead")
	if get_parent().get_node("Player").position.x - position.x > 100:
		direction = 1	
		if sign($Position2D.position.x) < 0:
			$Position2D.position.x *= -1
	
	if get_parent().get_node("Player").position.x - position.x <= -100:
		direction = -1
		if sign($Position2D.position.x) > 0:
			$Position2D.position.x *= -1
	
	if direction == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

	

		
func add_ball():
	var ball = null
	ball = BALL.instance()
	ball.set_speed(Vector2(450*direction, 0))
	get_parent().add_child(ball)
	ball.position = $Position2D.global_position
	print($Position2D.global_position)

func _on_Timer_timeout():
	if not is_dead and abs(global_position.x - get_parent().get_node("Player").global_position.x) <= 640:
		$AnimatedSprite.play("shoot")
		yield(get_tree().create_timer(0.5), "timeout")
		add_ball()
		$AnimatedSprite.play("idle")
