extends Area2D

var size
var initial_pos = Vector2()
var is_idle = false
export var delay = 0
export var limit = 0
export var speed = 1

func _ready():
	initial_pos = global_position
	$DelayTimer.wait_time = delay
	is_idle = true
	$DelayTimer.start()
	visible = false


func _physics_process(delta):
	if is_idle == false:
		visible = true
		global_position.y -= speed
	if global_position.y < limit:
		is_idle = true
		global_position = initial_pos
		$Timer.start()
		visible = false
		$CollisionShape2D.set_deferred("disabled", true) 



func _on_BubbleArea_body_entered(body):
	if "Player" in body.name:

		var pos = body.position
		body.set_is_floating(true)
		body.get_node("Tween").interpolate_property(body, "position", pos, global_position - Vector2(0, 32), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		body.get_node("Tween").start()
			


func _on_BubbleArea_body_exited(body):
	if "Player" in body.name:
		body.set_is_floating(false)
		#body.set_is_floating_jump(false)
		

func _on_VisibilityEnabler2D_viewport_entered(viewport):
	size = (viewport.size)


func _on_Timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false) 
	is_idle = false
	$Timer.stop()


func _on_DelayTimer_timeout():
	is_idle = false
	$DelayTimer.stop()
