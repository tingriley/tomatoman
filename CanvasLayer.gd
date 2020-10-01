extends CanvasLayer
onready var global = get_node("/root/Global")

func _ready():
	pass

func _process(delta):
	$Label.text = str(global.hp)

