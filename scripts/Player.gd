extends Entity


class_name Player

var _game_node = null
var _first_tick = true

# History vars
var _history = []
var _current_action = null
var _current_action_count = 0
var _timer : Timer = null


func _do_timer():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timer")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _ready():
	_game_node = get_node("/root/World")
	_visibility = VisibilityNotifier2D.new()
	_is_dead = false
	add_child(_visibility)
	
	_do_timer()

func _physics_process(delta):
	
	var x = 0
	if Input.is_action_pressed("left"):
		go_left()
	elif Input.is_action_pressed("right"):
		go_right()
	else:
		do_idle()
	if Input.is_action_just_pressed("jump"):
		do_jump()
	if(Input.is_action_pressed("down")):
		go_down()
	if(Input.is_action_pressed("attack")):
		do_attack()
	if (!_visibility.is_on_screen() and !_is_dead): # Fell out of screen
		if(_first_tick):
			_first_tick = false # Bug fix
		else:
			_die()
	if(is_jumping and _jump_accel>0):
		if(Input.is_action_pressed("jump")): # Increace jump speed if jump button remaines pressed
			_jump_accel-=JUMPACCELFADE/2
		else:
			_jump_accel-=JUMPACCELFADE*2
		motion.y -= _jump_accel
	_update_history()

func _update_history():
	var found_action = []
	if (Input.is_action_pressed("left")):
		found_action.append("left")
	elif (Input.is_action_pressed("right")):
		found_action.append("right")
	if (Input.is_action_pressed("down")):
		found_action.append("down")
	if (Input.is_action_pressed("jump")):
		found_action.append("jump")
	if (Input.is_action_pressed("attack")):
		found_action.append("attack")
	if(found_action.empty()):
		found_action.append("idle")


	
	if(_current_action == found_action):
		_current_action_count+=1
	else:
		_new_action(found_action)
	
func _die():
	_is_dead = true # Is set to false in Entity
	_save_action() # Save last action before death
	_game_node.player_died(_history)
	_history=[]
	_current_action = null
	_current_action_count = 0

func _new_action(new_action):
	if(_current_action == null):
		_current_action = new_action
		_current_action_count=1
	else:
		_save_action()
		_current_action = new_action
		_current_action_count=1
func _save_action():
	_history.append({"action":_current_action, "count":_current_action_count})

func print_locals():
	pass


func _on_timer():

#	print(get_node("/root/World/MainCamera").get_camera_screen_center())
#	print(get_viewport_rect())
	pass

