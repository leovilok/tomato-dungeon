extends Monstre

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 100.0+randi()%50
	strength = 10.0
	max_life = 30.0
	life = max_life
	orbe_type = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
