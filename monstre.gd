extends Node2D

class_name Monstre

var speed = 90
var target_dist = 25
var path = null
var life = 50.0
var max_life = 50.0
var strength = 10.0
var orbe_type = 0

var respawn_chance_per_kill = .01

var dead = false
var attacking = false

var mage
var mage_head
var sprite
var lifebar
var attack_area
var path_provider

var orbe_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	mage = get_node("../mage")
	mage_head = mage.get_node("Sprite/HeadArea")
	sprite = $Sprite
	lifebar = $lifebar
	attack_area = $Sprite/AttackArea
	path_provider = get_parent()
	
	orbe_scene = load("res://Orbe.tscn")

func right_angle(from, to):
	return round((from.angle_to_point(to)+PI)/(PI/2))*PI/2

func _on_death():
	var orbe = orbe_scene.instance()
	orbe.set_type(orbe_type)
	orbe.position = position
	get_node("..").add_child(orbe)
	
	mage.kills += 1
	
	if randf() < mage.kills * respawn_chance_per_kill:
		var spawners = get_tree().get_nodes_in_group("spawner")
		spawners[randi()%spawners.size()].spawn_monster()
		
	
	queue_free()

func process_life(_delta):
	if !dead:
		lifebar.scale.x = life/max_life
		if life <= 0:
			$HitSound.play()
			dead = true
			sprite.play("die")
			sprite.z_index = -2
			lifebar.scale.x = 0
			$lifebar_bg.scale.x = 0
			sprite.connect("animation_finished", self, "_on_death")
			if sprite.is_connected("animation_finished", self, "attack"):
				sprite.disconnect("animation_finished", self, "attack")

func attack():
	if attack_area.overlaps_area(mage_head):
		mage.life -= strength
		if !mage.over:
			mage.get_node("HitSound").play()
	attacking = false

func move(delta):
	var mage_pos = mage.position
	
	sprite.rotation = right_angle(position, mage_pos)
	
	if position.distance_to(mage_pos) > target_dist:
		if  mage.moving or path == null:
			path = path_provider.get_simple_path( position, mage_pos)
			path.remove(0)
		var distance = delta*speed
		var last_point = position
		var old_pos = position
		while path.size():
			var distance_between_points = last_point.distance_to(path[0])
			# The position to move to falls between two points.
			if distance <= distance_between_points:
				position = last_point.linear_interpolate(path[0], distance / distance_between_points)
				break
			# The position is past the end of the segment.
			distance -= distance_between_points
			last_point = path[0]
			path.remove(0)
		sprite.rotation = right_angle(old_pos, position)
		sprite.play("walk")
	else:
		attacking = true
		sprite.play("attack")
		if !mage.over:
			$AttackSound.play()
		if !sprite.is_connected("animation_finished", self, "attack"):
			sprite.connect("animation_finished", self, "attack")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_life(delta)
	if !dead and !attacking:
		move(delta)
