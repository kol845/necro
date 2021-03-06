extends Node2D

class_name Game

const RESPAWNTIME = 0.2

var _shadows = []

var _level = 1

var _spawn_timer : Timer = null
var spawn_index : int = 0

var _shadow_scene = load("res://scenes/Shadow.tscn")
var _player_scene = load("res://scenes/Player.tscn")

var _player = null

func empty_entities():
	for child in $EntityContainer.get_children():
		$EntityContainer.remove_child(child)

func player_died(player_history):
	empty_entities()
	var new_shadow = _shadow_scene.instance()
	_shadows.append(new_shadow)
	new_shadow.init(player_history)
#	$EntityContainer.add_child(new_shadow)

#	new_shadow.do_respawn()
	_spawn_timer.start()
	_next_spawn()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_timer = Timer.new() # Timer for spawning
	add_child(_spawn_timer)
	_spawn_timer.connect("timeout", self, "_next_spawn")
	_spawn_timer.set_wait_time(RESPAWNTIME)
	_spawn_timer.set_one_shot(false) # Make sure it loops
	
	_player = _player_scene.instance()
	$EntityContainer.add_child(_player)
	_player.respawn()
	pass

func _physics_process(delta):
	pass

func _stop_timer():
	_spawn_timer.stop()
	spawn_index = 0

func _next_spawn():
	print(_shadows.size())
	if(spawn_index<_shadows.size()):
		$EntityContainer.add_child(_shadows[spawn_index])
		_shadows[spawn_index].do_respawn()
	if(spawn_index==_shadows.size()): # Time to spawn player(last spawn)
		print("FUCKS")
		$EntityContainer.add_child(_player)
		_player.respawn()
	spawn_index+=1
	if(spawn_index>_shadows.size()):
		_stop_timer()
	pass
