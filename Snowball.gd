extends Area2D

const SPEED = 600
var velocity = Vector2(0, 0)
var direction = 1



func _ready():
	pass


func set_velocity(v):
	velocity = v

func set_direction(dir):
	direction = dir

func _physics_process(delta):
	#velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")

	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	if "Player" == body.name:
		body.dead()
	queue_free()




