extends Monstre

func _ready():
	speed = 50.0+randi()%20
	strength = 10.0
	max_life = 100.0
	life = max_life
	orbe_type = 1
	sprite.frames = $GolemSprite.frames
	$HitSound.pitch_scale = .5
	$AttackSound.stream = $AttackSoundGolem.stream

