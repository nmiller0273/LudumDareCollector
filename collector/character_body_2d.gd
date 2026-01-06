extends CharacterBody2D

@export var speed := 400.0

var hand_position = Vector2(300, 700)
var is_hovered = false
var dragging = false
var id = ""
var handIndex: int
var hover_position = Vector2(300, 500)
var spell_hovering = false
var mouse_pos = get_global_mouse_position()
var direction = Vector2(300, 700).normalized()
var centre_position = Vector2(576, 324)
var spell_text = ""

signal add_to_deck(card_id, target_player)

func set_id(value: String) -> void:
	BoardState.player_dies.connect(_on_player_dies_signal)
	BoardState.opponent_dies.connect(_on_opponent_dies_signal)
	id = value
	$cardSprite.set_card_display(id)
	if ResourceLoader.exists("res://creature_stats/" + id + ".tres"):
		var stat_file_name = "res://creature_stats/" + id + ".tres"
		var creature_stats
		creature_stats = load(stat_file_name).duplicate()
		$attackLabel.text = str(creature_stats.attack)
		$healthLabel.text = str(creature_stats.health)
		$spellLabel.queue_free()
	else:
		$attackLabel.queue_free()
		$healthLabel.queue_free()
		$attackSprite.queue_free()
		$healthSprite.queue_free()
		$spellLabel.text = str(spell_text)

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

func _process(delta: float) -> void:
	
	if spell_hovering == true:
		if $glowSprite.modulate.a > 0:
			$glowSprite.modulate.a -= 0.075
		direction = (centre_position - position).normalized()
		velocity = direction * speed * (position.distance_to(centre_position))/100
		move_and_slide()
		return
		
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
				if ResourceLoader.exists("res://creature_stats/" + id + ".tres"):
					self.queue_free()
				else:
					spell_hovering = true
					BoardState.valid_target.connect(_on_valid_spell_target)
					BoardState.spell_cancel.connect(_on_spell_cancel)
					
		CardManager.noLongerDragged()
		dragging = false
			
	if dragging == true:
		mouse_pos = get_global_mouse_position()
		if position.distance_to(mouse_pos) > 2:
			direction = (mouse_pos - position).normalized()
			velocity = direction * speed * (position.distance_to(mouse_pos))/100
		else:
			velocity = Vector2.ZERO
	else:
		if is_hovered == true:
			if position.distance_to(hover_position) > 2:
				direction = (hover_position - position).normalized()
				velocity = direction * speed * (position.distance_to(hover_position))/100
			else:
				velocity = Vector2.ZERO
			
		elif position.distance_to(hand_position) > 2:
			direction = (hand_position - position).normalized()
			velocity = direction * speed * (position.distance_to(hand_position))/100
		else:
			velocity = Vector2.ZERO

	move_and_slide()
	

# INFO : these all need both arguments so they can share reciever function with
# INFO : the code for receiving cards on board
func _on_player_dies_signal():
	emit_signal("add_to_deck", id, "Player")
	queue_free()
	
func _on_opponent_dies_signal():
	emit_signal("add_to_deck", id, "Player")
	queue_free()

func _on_valid_spell_target():
	emit_signal("add_to_deck", id, "Opponent")
	queue_free()

func _on_spell_cancel():
	spell_hovering = false
