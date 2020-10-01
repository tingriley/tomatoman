extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var direction = -1 # left

var is_dead = false

onready var player_vars = get_node("/root/Global")

export(int) var speed = 80 # edit in the inspector
export(int) var hp = 1
export(Vector2) var size = Vector2(1, 1)

const BULLET = preload("Bullet.tscn")

func _ready():
	scale = size
		
		
	pass # Replace with function body.


	
func dead(damage):
	hp -= damage 

	if hp <= 0:
		is_dead = true
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true) 

		$Timer.start()
		
		if scale > Vector2(1, 1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
			

func _physics_process(delta):
	if is_dead == false:
		velocity.x = speed * direction
			
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("walk")
	
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)


	else:
		if is_on_floor():
			velocity = Vector2(120, -400)
		velocity = move_and_slide(velocity, FLOOR)
		velocity.y += GRAVITY
		
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:  # need to move the raycast
		direction *= -1
		$RayCast2D.position.x *= -1
	
					
func _on_Timer_timeout():
	queue_free()



func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()


func shoot():
	var bullet = null
	bullet = BULLET.instance()
	bullet.set_fireball_direction(direction)

	get_parent().add_child(bullet)
	bullet.position = $RayCast2D.global_position + Vector2(25*direction, 0)
	

func _on_ThrowTimer_timeout():
	shoot()
