extends Area2D

enum {TYPE_DIABLE, TYPE_GOLEM, TYPE_LANCEUR, TYPE_SERPENT}

var type = TYPE_DIABLE

func set_type(t):
	type = t
	match t:
		TYPE_DIABLE:
			$AnimatedSprite.play("diable")
		TYPE_GOLEM:
			$AnimatedSprite.play("golem")
		TYPE_LANCEUR:
			$AnimatedSprite.play("lanceur")
		TYPE_SERPENT:
			$AnimatedSprite.play("serpent")

func _ready():
	$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
