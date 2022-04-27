extends Node2D


var step = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func avance():
		step += 1
		match step:
			2:
				$Cine2.visible = true
			3:
				$Cine3.visible = true
			4:
				$Cine4.visible = true
			_:
				get_tree().change_scene("res://titre.tscn")
	

func _input(event):
	if event.is_pressed():
		avance()
