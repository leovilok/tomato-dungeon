extends Monstre

var spell_scene

func _ready():
	target_dist = 150
	orbe_type = 2
	
	spell_scene = load("res://Spell.tscn")
	path_provider = get_node("../AlternativeNavigation")
	z_index = 3

func attack():
	var newspell = spell_scene.instance()
	newspell.position = $Sprite/SpellSpawn.global_position
	var mov = mage.position - newspell.position
	newspell.movement = mov.normalized() * newspell.speed
	
	newspell.thrower = get_node(".")
	
	get_node("..").add_child(newspell)
	
	attacking = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
