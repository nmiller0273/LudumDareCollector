extends Node2D

var slot_targeted = -1
var side_targeted = "None"
var clicked = false
var target = [-1, "None"]
var spell = ""
var played_by = ""

signal target_clicked(target_slot, target_side, spell, played_by)
signal spell_cancelled()

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	$sprite1.rotate(0.015)
	$sprite2.rotate(-0.015)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if clicked == false:
			clicked = true
			target = [slot_targeted, side_targeted]
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		print("exit time")
		emit_signal("spell_cancelled")
		queue_free()
	else:
		clicked = false
			
	if 290 < position[0] and position[0] < 450:
		side_targeted = "Player"
	elif 693 < position[0] and position[0] < 853:
		side_targeted = "Opponent"
	else:
		side_targeted = "None"
		return
	if 20 < position[1] and position[1] < 150:
		slot_targeted = 0
	elif 150 < position[1] and position[1] < 300:
		slot_targeted = 1
	elif 300 < position[1] and position[1] < 460:
		slot_targeted = 2
	else:
		slot_targeted = -1
		return
	
	if target == [slot_targeted, side_targeted] and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if slot_targeted != -1 and side_targeted != "None":
			emit_signal("target_clicked", slot_targeted, side_targeted, spell, played_by)
			
func _on_valid_target():
	queue_free()
	
