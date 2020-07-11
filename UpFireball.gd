extends Area2D

const SPEED = 800
var velocity = Vector2()
var direction = -1


func _ready():
	$Timer.start()


func set_direction(dir):
	direction = dir

func _physics_process(delta):
	velocity.y = (SPEED + abs(get_parent().get_node("Player").velocity.y)) * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	if "Boss" == body.name:
		body.dead()
	if "FlyingEnemy" == body.name:
		body.get_parent().dead()
	elif "Enemy" in body.name:
		body.dead()
	queue_free()


func _on_Timer_timeout():
	queue_free()

