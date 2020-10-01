extends KinematicBody2D

const FLOOR = Vector2(0, -1)
var velocity = Vector2(0, -200)
var play = false

func _ready():
	$AnimatedSprite.play("idle")

func _physics_process(delta):
	velocity = move_and_slide(velocity, FLOOR)
	velocity.y += 20
	if is_on_floor():
		if abs(get_parent().get_parent().get_node("Player").position.x - position.x) <= 600:
			if not $AudioStreamPlayer2D.playing:
				$AudioStreamPlayer2D.play()
		$AnimatedSprite.play("explode")
		yield(get_tree().create_timer(0.3), "timeout")
		queue_free()

	


func _on_Area2D_body_entered(body):
	if "Player"  in body.name:
		body.dead()
