extends Area2D

var speed = 100.0
var movement = Vector2(1, 0)
var strength = 10.0
var lvl = 0

var thrower = null

var mage
var mage_head

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = movement.angle()
	mage = get_node("../mage")
	mage_head = mage.get_node("Sprite/HeadArea")
	match lvl:
		0:
			$Sprite.play("white")
		1:
			$Sprite.play("green")
		2:
			$Sprite.play("blue")
		3:
			$Sprite.play("purple")
		_:
			$Sprite.play("red")
	
	if lvl != 0:
		strength = mage.strength * 0.5 * lvl
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += movement*delta
	if get_parent().get_closest_point(position) != position:
		queue_free()
	if lvl == 0: # monster spell
		if overlaps_area(mage_head):
			mage.life -= strength
			if !mage.over:
				mage.get_node("HitSound").play()
			queue_free()
	#else: # mage spell
	for monstre in get_tree().get_nodes_in_group("monstres"):
		if monstre != thrower and overlaps_area(monstre.get_node("Sprite/HitArea")):
			monstre.life -= strength
			queue_free()
