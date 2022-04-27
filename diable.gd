extends Monstre

# Called when the node enters the scene tree for the first time.
func _ready():
	target_dist = 25
	speed = 60+randi()%40
	strength = 20
