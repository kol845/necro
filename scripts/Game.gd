extends Node2D

class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _shadows = []


var _shadow_scene = load("res://scenes/Shadow.tscn")

func player_died(player_history):

#	var new_shadow = Shadow.new()
	var new_shadow = _shadow_scene.instance()
	new_shadow.init(player_history)
	$EntityContainer.add_child(new_shadow) # Here 
	for shadow in _shadows:
		shadow.do_respawn()
	_shadows.append(new_shadow)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
