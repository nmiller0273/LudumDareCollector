extends CharacterBody2D

@export var speed := 400.0

var hand_position = Vector2(300, 700)
var is_hovered = false
var dragging = false
var id = ""
var handIndex: int
var hover_position = Vector2(300, 500)

func set_id(value: String) -> void:
	id = value
	$cardSprite.set_card_display(id)
	if ResourceLoader.exists("res://creature_stats/" + id + ".tres"):
		var stat_file_name = "res://creature_stats/" + id + ".tres"
		var creature_stats
		creature_stats = load(stat_file_name).duplicate()
		$attackLabel.text = str(creature_stats.attack)
		$healthLabel.text = str(creature_stats.health)
	else:
		$attackLabel.queue_free()
		$healthLabel.queue_free()
		$attackSprite.queue_free()
		$healthSprite.queue_free()

func set_hand_pos(handInd: int):
	handIndex = handInd
	hand_position = Vector2((250 + 100*handIndex), 700)
	hover_position = Vector2((250 + 100*handIndex), 500)
	
func setup(new_id: String, handInd: int):
	set_id(new_id)
	set_hand_pos(handInd)

func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
func _on_area_2d_mouse_exited() -> void:
	is_hovered = false

func _physics_process(delta: float) -> void:
	if position[1] < 350 and dragging == true:
		$glowSprite.modulate.a += 0.05
	else:
		if $glowSprite.modulate.a > 0:
			$glowSprite.modulate.a -= 0.075
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		
		if (is_hovered == true) and (dragging == false) and (CardManager.checkDraggingAny() == false):
			dragging = true
			CardManager.nowDragged()
			
	elif dragging == true:
		if position[1] < 350:
			if BoardState.processCard(id, "Player") == true:
				self.queue_free()
		CardManager.noLongerDragged()
		dragging = false
			
	if dragging == true:
		var mouse_pos = get_global_mouse_position()
		if position.distance_to(mouse_pos) > 2:
			var direction = (mouse_pos - position).normalized()
			velocity = direction * speed * (position.distance_to(mouse_pos))/100
		else:
			velocity = Vector2.ZERO
	else:
		if is_hovered == true:
			if position.distance_to(hover_position) > 2:
				var direction = (hover_position - position).normalized()
				velocity = direction * speed * (position.distance_to(hover_position))/100
			else:
				velocity = Vector2.ZERO
			
		elif position.distance_to(hand_position) > 2:
			var direction = (hand_position - position).normalized()
			velocity = direction * speed * (position.distance_to(hand_position))/100
		else:
			velocity = Vector2.ZERO

	move_and_slide()
