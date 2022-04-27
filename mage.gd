extends Node2D

export var speed = 100.0
export var max_life = 50.0
export var strength = 10.0
export var spell_level = 0

export var max_speed = 200.0
export var min_speed = 50.0
export var max_max_life = 150.0
export var min_max_life = 15.0
export var max_strength = 100.0
export var min_strength = 2.0
export var max_spell_level = 10

var life = max_life
var life_full_size = 100.0

var attack_time = 0
var attack_duration = .5
var attack_dist = 30


var kills = 0

var moving = true

var over = false

var sprite
var attbar
var lifebar
var lifebar_bg
var head_area
var spell_scene
var label

	#life -= delta*5

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite
	lifebar = $lifebar
	lifebar_bg = $lifebar_bg
	attbar = $attbar
	head_area = $Sprite/HeadArea
	
	label = get_node("../../CanvasLayer/stats")
	display_stats()
	
	spell_scene = load("res://Spell.tscn")
	

func process_life(_delta):
	if !over and life <= 0:
		over = true
		game_over()
	elif over:
		life = 0
	
	lifebar.scale.x = life/life_full_size
	

func move(delta):
	var pos = position
	
	#sprite.rotation = PI/2
	
	var mov = Vector2(0,0)
	
	if Input.is_action_pressed("ui_right"):
		mov.x += 1
		sprite.rotation = 0
	if Input.is_action_pressed("ui_left"):
		mov.x -= 1
		#sprite.rotation += PI/2
		sprite.rotation = PI
	if Input.is_action_pressed("ui_up"):
		mov.y -= 1
		sprite.rotation = -PI/2
	if Input.is_action_pressed("ui_down"):
		mov.y += 1
		sprite.rotation = PI/2
	
	if mov != Vector2(0, 0):
		pos += mov.normalized()*delta*speed
		pos = get_parent().get_closest_point(pos)
	
	if pos != position:
		moving = true
		position = pos
		sprite.play("walk")
	else:
		moving = false
		sprite.stop()

func attack():
	for monstre in get_tree().get_nodes_in_group("monstres"):
		#if position.distance_to(monstre.position) < attack_dist:
		if get_node("Sprite/AttackArea").overlaps_area(monstre.get_node("Sprite/HitArea")):
			monstre.life -= strength

func spell():
	var newspell = spell_scene.instance()
	newspell.position = $Sprite/SpellSpawn.global_position
	var mov = Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		mov.x += 1
	if Input.is_action_pressed("ui_left"):
		mov.x -= 1
	if Input.is_action_pressed("ui_up"):
		mov.y -= 1
	if Input.is_action_pressed("ui_down"):
		mov.y += 1
	
	if mov == Vector2(0,0):
		mov = newspell.movement.rotated(sprite.rotation)
	
	newspell.speed *= 0.5 + 0.3*spell_level
	
	newspell.movement = mov.normalized() * newspell.speed
	newspell.lvl = spell_level
	
	get_node("..").add_child(newspell)

func process_attack(delta):
	if Input.is_action_pressed("ui_accept") and attack_time == 0:
		attack_time = attack_duration
		$AttackSound.play()
	elif attack_time > 0:
		attack_time -= delta
		attbar.scale.x = (attack_duration - attack_time)/attack_duration
		sprite.play("attack")
		if attack_time < 0:
			attack_time = 0
			attbar.scale.x = 0
			sprite.frame = 0
			attack()
			if spell_level > 0:
				spell()

func game_over():
	var niveau = get_node("../..")
	niveau.get_node("CanvasLayer/GameOver").visible = true
	niveau.get_node("CanvasModulate").visible = true
	niveau.get_node("CanvasModulate/AnimationPlayer").play("fade")
	niveau.get_node("CanvasLayer/killcount").text = "Kills: " + String(kills)
	niveau.get_node("CanvasLayer/killcount").visible = true
	
	$Music.stop()
	$GameOverMusic.play()

func process_orbs():
	for orbe in get_tree().get_nodes_in_group("orbes"):
		if orbe.overlaps_area(head_area):
			match orbe.type:
				orbe.TYPE_DIABLE:
					strength += 5
					
					max_life -= 3
					speed -= 2
				orbe.TYPE_GOLEM:
					max_life += 10
					
					speed -= 3
					strength -= 1
					
				orbe.TYPE_LANCEUR:
					if spell_level < max_spell_level:
						spell_level += 1
					
					speed -= 1
					strength -= 1
					max_life -= 1
				orbe.TYPE_SERPENT:
					speed += 10
					
					strength -= 2
					max_life -= 2
			
			speed = clamp(speed, min_speed, max_speed)
			max_life = clamp(max_life, min_max_life, max_max_life)
			strength = clamp(strength, min_strength, max_strength)
			
			
			lifebar_bg.scale.x = max_life/life_full_size
			life = min(life+10, max_life)
			
			display_stats()
			
			$OrbeSound.play()
			
			orbe.queue_free()

func display_stats():
	label.text = "CON: " + String(max_life)
	label.text += "\nSTR: " + String(strength)
	label.text += "\nSPD: " + String(speed)
	label.text += "\nINT: " + String(spell_level)

func _process(delta):
	if over:
		return
	
	process_attack(delta)
	if attack_time == 0:
		move(delta)
	process_orbs()
	process_life(delta)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		get_tree().change_scene("res://titre.tscn")
