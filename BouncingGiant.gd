extends KinematicBody2D

const GRAVITY = 20
const FLOOR = Vector2(0, -1)

var velocity = Vector2(0, 300)

var direction = -1 # left

var is_dead = false
var is_damage = false

onready var player_vars = get_node("/root/Global")

export(int) var speed = 80 # edit in the inspector
export(int) var hp = 10
export(Vector2) var size = Vector2(1, 1)


func _ready():
	scale = size
	$AnimatedSprite.play("idle")
	
func dead(damage):
	hp -= damage 
	is_damage = true
	
	if hp <= 0:
		is_dead = true
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true) 

		$Timer.start()
		if scale > Vector2(1, 1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
			
func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)



			
func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if not is_dead:
		if "Player" in body.name:
			body.dead()
