extends Node2D

var slot_targeted = -1
var side_targeted = "None"
var clicked = false
var target = [-1, "None"]

signal target_clicked(target_slot, target_side)

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	self.rotate(0.015)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if clicked == false:
			clicked = true
			target = [slot_targeted, side_targeted]
	else:
		clicked = false
			
	if 290 < position[0] and position[0] < 450:
		side_targeted = "Player"
		$Label.text = "1"
	elif 693 < position[0] and position[0] < 853:
		side_targeted = "Opponent"
		$Label.text = "2"
	else:
		side_targeted = "None"
		$Label.text = "-1"
		return
	if 20 < position[1] and position[1] < 150:
		slot_targeted = 0
		$Label2.text = "0"
	elif 150 < position[1] and position[1] < 300:
		slot_targeted = 1
		$Label2.text = "1"
	elif 300 < position[1] and position[1] < 460:
		slot_targeted = 2
		$Label2.text = "2"
	else:
		slot_targeted = -1
		$Label2.text = "-1"
		return
	
	if target == [slot_targeted, side_targeted] and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if slot_targeted != -1 and side_targeted != "None":
			emit_signal("target_clicked", slot_targeted, side_targeted)
			queue_free()
