extends KinematicBody2D

const SNOWBALL = preload("Snowball.tscn")
const FLOOR = Vector2(0, -1)
const MAX_JUMP_HEIGHT = 64*4
onready var player = get_parent().get_node("Player")

var jump_duration = 0.45
var hp = 2
var direction = 1 #right
var player_position = Vector2(0, 0)
var velocity = Vector2(0, 0)
var is_jumping = false

var gravity
var max_jump_velocity 
	
func _ready():
	$AnimatedSprite.play("idle")
	player_position = player.position
	gravity = 2*MAX_JUMP_HEIGHT / pow(jump_duration, 2)      # s = 1/2 at^2
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT) # v^2 = 2as
	

func flip():
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	$Position2D.position.x *= -1
	direction*=-1

func dead(damage):
	hp -= damage
	$AnimatedSprite.play("damage")
	yield(get_tree().create_timer(0.7), "timeout")
	$AnimatedSprite.play("idle")
		
	if hp <= 0:
		get_parent().get_node("Shake").screen_shake(1, 10, 100)
		$AnimatedSprite.play("die")
		#yield(get_tree().create_timer(0.5), "timeout")
		#queue_free()
		

		

func shoot():
	var snowball = null
	snowball = SNOWBALL.instance()
	var dv = player_position - position
	dv = dv.normalized()
	snowball.set_velocity(dv * 15)
	get_parent().add_child(snowball)
	snowball.position = $Position2D.global_position

func _physics_process(delta):
	if velocity.x == 0:
		if player_position.x > position.x and direction == -1:
			flip()
		if player_position.x < position.x and direction == 1:
			flip()
	if player_position.y <= 500 and position.y >= 500:
		if is_on_floor():
			velocity.y = max_jump_velocity
			is_jumping = true
	

	if velocity.y > 0:
		is_jumping = false
		
	velocity.y += gravity*delta
	velocity = move_and_slide(velocity, FLOOR)
	
func _on_Timer_timeout():
	if velocity.x == 0:
		$AnimatedSprite.play("attack")
		yield(get_tree().create_timer(0.4), "timeout")
		
		shoot()
		yield(get_tree().create_timer(0.2), "timeout")
		shoot()
		yield(get_tree().create_timer(0.2), "timeout")
		
		$AnimatedSprite.play("idle")


func _on_PlayerPositionTimer_timeout():
	player_position = player.position


func _on_WalkTimer_timeout():
	velocity.x = direction * 400
	yield(get_tree().create_timer(1.25), "timeout")
	velocity.x = 0
