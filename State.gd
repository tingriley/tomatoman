extends StateMachine

var alpha = 0.5
func _ready():
	add_state("idle")
	add_state("run")
	add_state("attack")
	add_state("jump")
	add_state("fall")
	add_state("dead")
	add_state("damage")
	add_state("back")
	add_state("ladder")
	add_state("drift")
	add_state("fast")
	state = states.idle
	

func _state_logic(delta):
	pass


func _get_transition(delta):
	if parent.is_dead:
		return states.dead
	
	match state:
		states.idle:
			if parent.is_damage:
				return states.damage
			if parent.is_back:
				return states.back
			if parent.is_climbing_up or parent.is_climbing_down:
				return states.ladder
			if not parent.is_on_floor():
				if parent.velocity.y < 0 :
					return states.jump
				if parent.velocity.y > 0 :
					return states.fall
			if parent.velocity.x != 0:
				if parent.is_fast:
					return states.fast
				else:
					return states.run
		states.run:
			if parent.is_damage:
				return states.damage
			if parent.is_back:
				return states.back
			if parent.is_climbing_up or parent.is_climbing_down:
				return states.ladder
			if not parent.is_on_floor():
				if parent.velocity.y < 0 :
					return states.jump
				if parent.velocity.y > 0 :
					return states.fall
			if parent.velocity.x == 0:
				return states.idle
			if parent.velocity.x != 0:
				if parent.is_fast:
					return states.fast
				else:
					return states.run
		states.jump:
			if parent.is_damage:
				return states.damage
			if parent.is_back:
				return states.back
			if parent.is_drift:
				return states.drift
			if parent.is_climbing_up or parent.is_climbing_down:
				return states.ladder
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall        
		states.fall:
			if parent.is_damage:
				return states.damage
			if parent.is_back:
				return states.back
			if parent.is_drift:
				return states.drift
			if parent.is_climbing_up or parent.is_climbing_down:
				return states.ladder
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.damage:
			if not parent.is_damage:
				return states.idle
		states.back:
			if not parent.is_back:
				return states.idle
			if parent.is_climbing_up or parent.is_climbing_down:
				return states.ladder
		states.ladder:
			if not parent.is_on_ladder or parent.is_on_floor():
				return states.idle
		states.drift:
			if not parent.is_drift:
				return states.idle
		states.fast:
			if not parent.is_fast:
				return states.idle


	return null


func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.run:
			parent.anim_player.play("run")        
		states.jump:
			parent.anim_player.play("jump")        
		states.fall:
			parent.anim_player.play("jump")
		states.dead:
			parent.anim_player.play("dead")
		states.damage:
			parent.anim_player.play("damage")
		states.back:
			parent.anim_player.play("back")
		states.ladder:
			parent.anim_player.play("back")
		states.drift:
			parent.anim_player.play("drift")		
		states.fast:
			parent.anim_player.play("fast")

				


func _exit_state(old_state, new_state):
	pass
