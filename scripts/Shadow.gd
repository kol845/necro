extends Entity


class_name Shadow

var _history = []
var _history_i = 0
var _current_action_count = 0
var _current_action = null
var _is_depleated = false 


# action = {action:string, count:int}

func _ready():
	pass

func init(history):
	_history = history
	_current_action = _history[_history_i]

func _physics_process(delta):
	if(!_is_depleated):
		_do_action()
	if(is_jumping and _jump_accel>0):
		if("jump" in _current_action.action): # Increace jump speed if jump button remaines pressed
			_jump_accel-=JUMPACCELFADE/2
		else:
			_jump_accel-=JUMPACCELFADE*2
		motion.y -= _jump_accel

func _do_action():


	if(_current_action_count<=0):
		_history_i+=1
		if(_history_i >= _history.size()):
			_is_depleated = true
		else:
			_current_action = _history[_history_i]
			_current_action_count = _current_action.count
			_do_action()
	else:
		for action in _current_action.action:
			match(action):
				"left":
					go_left()
				"right":
					go_right()
				"jump":
					do_jump()
				"down":
					go_down()
				"idle":
					do_idle()
		_current_action_count -= 1
	
func do_respawn():
	_history_i=0
	_current_action = _history[_history_i]
	_current_action_count = _current_action.count
	_is_depleated = false
	respawn()
	
func test():
	print("fuck")
