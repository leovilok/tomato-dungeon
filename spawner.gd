extends Position2D

var max_wait = 20
var target_max_wait = 7

var max_monsters = 200

export var prefered = -1
export var bias = .5

var monstres_scn

# Called when the node enters the scene tree for the first time.
func _ready():
	monstres_scn = [
		load("res://diable.tscn"),
		load("res://golem.tscn"),
		load("res://throw.tscn"),
		load("res://serpent.tscn")
	]


func spawn_monster():
	
	var id = randi()%4
	
	if prefered != -1 and randf() < bias:
		id = prefered
	
	var monster = monstres_scn[id].instance()
	monster.position = position
	
	get_parent().add_child(monster)

func _on_Timer_timeout():
	if get_tree().get_nodes_in_group("monstres").size() < max_monsters:
		spawn_monster()
	if max_wait > target_max_wait:
		max_wait -= 1
	$Timer.start(randi() % max_wait)
