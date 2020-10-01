extends RichTextLabel


var dialog = ["You found a gun! Press X to shoot", 
"You found a key!", 
"Gun upgraded! Now you can hit through walls!!", 
"Health Point Increased", 
"You found a spring! Now you can double jump!!", 
"You found a wing! Hold Z to drift!!"]

var current_page = 0
var ch = 0

func _ready():
	set_bbcode(dialog[current_page])
	set_visible_characters(0)

func set_code(page):
	set_bbcode(dialog[page])
	set_visible_characters(0)
	current_page = page
	
func _on_Timer_timeout():

	set_visible_characters(get_visible_characters()+1)
	if get_visible_characters() >= len(dialog[current_page]):
		#yield(get_tree().create_timer(10), "timeout")
		get_parent().get_node("Timer").stop()
		

