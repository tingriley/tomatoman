extends Area2D


func _ready():
	pass


func _on_BlueEnemy_body_entered(body):
	if "Player" in body.name:
		body.dead()
