extends Node2D

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	self.rotate(0.015)
	if 290 < position[0] and position[0] < 450:
		$Label.text = "1"
	elif 693 < position[0] and position[0] < 853:
		$Label.text = "2"
	else:
		$Label.text = "-1"
		return
	if 20 < position[1] and position[1] < 150:
		$Label2.text = "0"
	elif 150 < position[1] and position[1] < 300:
		$Label2.text = "1"
	elif 300 < position[1] and position[1] < 460:
		$Label2.text = "2"
	else:
		$Label2.text = "-1"
		
