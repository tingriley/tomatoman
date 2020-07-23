extends Tween




# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func tween_position(x,y):
	var player = get_parent()
	interpolate_property(player, "position",
			player.position, Vector2(x,y), 0.25,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	start()

