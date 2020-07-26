extends CanvasLayer
onready var global = get_node("/root/Global")

func _ready():
	pass

func _process(delta):
	$Label2.text = str(global.score)
	$Label3.text = str(global.coin)
