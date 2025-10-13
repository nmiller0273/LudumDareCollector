extends Node2D

const halloween_card_ids = ["Zombwell", "Dracula", "Ghost", "Bigfoot", "Invisible_Guy", "Mummy", "Frankenstein", "Werewolf", "Curse", "Let_Loose"]
const wizard_card_ids = ["Death_Wizard", "Summoner_Wizard", "Nature_Wizard", "Fire_Wizard"]
const boo_id = ["Boo"]
var hand_card_scene = preload("res://cardInHand.tscn") 
var bg_scene = preload("res://background.tscn") 
var card_ids = []
var player_deck = []
var opponent_deck = []
var hand_fill = [null, null, null, null, null, null, null,]
var card_in_deck_sprites_player = []
var card_in_deck_sprites_opponent = []

signal opponent_draw_signal(card_id)

func first_time_setup(sets_in_play : Array):
	BoardState.played_card.connect(_on_card_played)
	BoardState.creature_add_to_deck_signal_two.connect(_on_creature_add_to_deck_signal_two)
	BoardState.player_draw.connect(_on_player_draw_signal)
	BoardState.opponent_draw.connect(_on_opponent_draw_signal)
	BoardState.player_dies.connect(_on_player_dies_signal)
	BoardState.opponent_dies.connect(_on_opponent_dies_signal)
	self.connect("opponent_draw_signal", Callable(OpponentTurn, "_on_opponent_draw"))
	card_ids.append_array(boo_id)
	if "halloween" in sets_in_play:
		card_ids.append_array(halloween_card_ids)
	if "wizards" in sets_in_play:
		card_ids.append_array(wizard_card_ids)
		
	var available_ids = card_ids.duplicate()
	available_ids.shuffle()
	while len(available_ids) > 1:
		opponent_deck.append(available_ids.pop_front())
		player_deck.append(available_ids.pop_front())
	if len(available_ids) == 1:
		opponent_deck.append(available_ids.pop_front())
	
	var bg = bg_scene.instantiate()
	add_child(bg)
	game_setup()
	
func game_setup():
	BoardState.start_of_game()
	
	var z_ind_reference = 0
	
	for card_in_deck in player_deck:
		z_ind_reference = -100
		var card_in_deck_sprite = Sprite2D.new()
		card_in_deck_sprite.texture = preload("res://sprites/deckBlank.png")
		card_in_deck_sprite.position = Vector2(175, (600 - len(card_in_deck_sprites_player)*10))
		card_in_deck_sprite.z_index = z_ind_reference
		card_in_deck_sprite.z_as_relative = false
		z_ind_reference = z_ind_reference + 1
		add_child(card_in_deck_sprite)
		card_in_deck_sprites_player.append(card_in_deck_sprite)
	
	for card_in_deck in opponent_deck:
		z_ind_reference = -100
		var card_in_deck_sprite = Sprite2D.new()
		card_in_deck_sprite.texture = preload("res://sprites/deckBlank.png")
		card_in_deck_sprite.position = Vector2(1050, (600 - len(card_in_deck_sprites_opponent)*10))
		card_in_deck_sprite.z_index = z_ind_reference
		z_ind_reference = z_ind_reference + 1
		card_in_deck_sprite.z_as_relative = false
		add_child(card_in_deck_sprite)
		card_in_deck_sprites_opponent.append(card_in_deck_sprite)

	for i in range(5):
		player_draw()
		await get_tree().create_timer(0.5).timeout
		opponent_draw()
		await get_tree().create_timer(0.1).timeout
		
func player_draw():
	if player_deck.is_empty():
		return
	for i in range(len(hand_fill)):
		if hand_fill[i] == null:
			var newCard = hand_card_scene.instantiate()
			add_child(newCard)
			var id = player_deck.pop_back()
			newCard.get_node("handCard").setup(id, i) 
			hand_fill[i] = id
			card_in_deck_sprites_player.pop_back().queue_free()
			return

func opponent_draw():
	if opponent_deck.is_empty():
		return
	if len(OpponentTurn.opponent_hand) >= 7:
		return
	var id = opponent_deck.pop_back()
	card_in_deck_sprites_opponent.pop_back().queue_free()
	emit_signal("opponent_draw_signal", id)

func _on_card_played(card_name: String):
	for i in range(len(hand_fill)):
		if hand_fill[i] == card_name:
			hand_fill[i] = null
			return

func _on_button_draw_card_start_of_turn() -> void:
	player_draw()
	await get_tree().create_timer(0.5).timeout

func _on_player_draw_signal(draw_type):
	if draw_type == 0:
		player_draw()
	elif draw_type == "Creature":
		#check cards until find a creature
		pass
	elif draw_type == "Spell":
		#check cards until find a spell
		pass

func _on_opponent_draw_signal(draw_type):
	if draw_type == 0:
		opponent_draw()
	elif draw_type == "Creature":
		#check cards until find a creature
		pass
	elif draw_type == "Spell":
		#check cards until find a spell
		pass
	
func _on_creature_add_to_deck_signal_two(creature_id, target_player) -> void:
	if target_player == "Player":
		player_deck.push_front(creature_id)
		for card_in_deck_sprite in card_in_deck_sprites_player:
			card_in_deck_sprite.position = card_in_deck_sprite.position - Vector2(0, 10)
		var card_in_deck_sprite = Sprite2D.new()
		card_in_deck_sprite.texture = preload("res://sprites/deckBlank.png")
		card_in_deck_sprite.position = Vector2(175, 600)
		card_in_deck_sprite.z_as_relative = false
		if card_in_deck_sprites_player.is_empty() != true:
			card_in_deck_sprite.z_index = card_in_deck_sprites_player[0].z_index - 1
		add_child(card_in_deck_sprite)
		card_in_deck_sprites_player.push_front(card_in_deck_sprite)
	else:
		opponent_deck.push_front(creature_id)
		for card_in_deck_sprite in card_in_deck_sprites_opponent:
			card_in_deck_sprite.position = card_in_deck_sprite.position - Vector2(0, 10)
		var card_in_deck_sprite = Sprite2D.new()
		card_in_deck_sprite.texture = preload("res://sprites/deckBlank.png")
		card_in_deck_sprite.position = Vector2(1050, 600)
		card_in_deck_sprite.z_as_relative = false
		if card_in_deck_sprites_opponent.is_empty() != true:
			card_in_deck_sprite.z_index = card_in_deck_sprites_opponent[0].z_index - 1
		add_child(card_in_deck_sprite)
		card_in_deck_sprites_opponent.push_front(card_in_deck_sprite)
	
	print("player deck: ", player_deck)
	print("opponent deck: ", opponent_deck)

func _on_player_dies_signal():
	pass
	
func _on_opponent_dies_signal():
	pass
