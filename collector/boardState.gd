extends Node

signal player_takes_damage(damage: int)
signal opponent_takes_damage(damage: int)
signal player_dies()
signal opponent_dies()
signal played_card(card_id)
signal creature_add_to_deck_signal_two(creature_id, target_player)
signal player_draw(draw_type)
signal opponent_draw(draw_type)

var player_health: int
		
var opponent_health: int
		
var playerCreatures = [null,null,null]
var opponentCreatures = [null,null,null]
var creature_on_board = preload("res://boardCards.tscn")

var spell_index = {
	"Boo" : 0,
	"Future_Visions" : 1,
	"Vampiric_Beguilement" : 2,
	"Full_Moon" : 3,
	"Haunting" : 4,
	"Spark_Of_Life" : 5,
	"Fireball" : 6,
	"Avalanche" : 7,
	"Raise_Dead" : 8,
	"Restore_Life" : 9,
	"Scour_Tomes" : 10,
	"Abduct" : 11,
	"Stimpack" : 12,
	"Inderdimensional_Knowledge" : 13,
	"Laser_Volley" : 14,
	"Let_Loose": 15
}

func start_of_game():
	opponent_health = 15
	player_health = 15

func end_of_game(winner: String):
	var spoils_for_winner = []
	
	for creature in playerCreatures:
		if creature != null:
			spoils_for_winner.append(creature)
			creature = null
			
	for creature in opponentCreatures:
		if creature != null:
			spoils_for_winner.append(creature)
			creature = null
	
	for card in spoils_for_winner:
		print(card, " ", winner)
		card.queue_free()
		emit_signal("creature_add_to_deck_signal_two", card.get_node("cardOnBoard").id, winner)
		await get_tree().create_timer(0.2).timeout

func getCreature(creatureName, spot, playedBy):
	if playedBy == "Player":
		emit_signal("played_card", creatureName)
	var new_creature = creature_on_board.instantiate()
	add_child(new_creature)
	new_creature.get_node("cardOnBoard").setup(creatureName, spot, playedBy)
	new_creature.get_node("cardOnBoard").connect("creature_add_to_deck", Callable(self, "_on_creature_add_to_deck"))

	return new_creature

func processCard(id, played_by, target = null) -> bool:
	if ResourceLoader.exists("res://creature_stats/" + id + ".tres"):
		print("played creature" + id)
		if played_by == "Player":
			if null in playerCreatures:
				for k in range(len(playerCreatures)):
					if playerCreatures[k] == null:
						var created = getCreature(id, k, "Player")
						playerCreatures[k] = created
						break
			else:
				print("no room!")
				return false
			print(playerCreatures)
			return true
		else:
			if null in opponentCreatures:
				for k in range(len(opponentCreatures)):
					if opponentCreatures[k] == null:
						var created = getCreature(id, k, "Opponent")
						opponentCreatures[k] = created
						break
			else:
				print("no room!")
				return false
			return true
	else:
		spell_lookup(spell_index[id], played_by, target)
		return true

func change_opponent_health(change):
	emit_signal("opponent_takes_damage", change)
	opponent_health -= change
	if opponent_health <= 0:
		emit_signal("opponent_dies")
		end_of_game("Player")
		
func change_player_health(change):
	emit_signal("player_takes_damage", change)
	player_health -= change
	if player_health <= 0:
		emit_signal("player_dies")
		end_of_game("Opponent")

func _on_creature_add_to_deck(creature_id, target_player):
	if target_player == "Opponent":
		emit_signal("creature_add_to_deck_signal_two", creature_id, "Player")
	else:
		emit_signal("creature_add_to_deck_signal_two", creature_id, "Opponent")
		
			
func spell_lookup(spell_id: int, played_by: String, target = null):
	print("spell lookup for: ", spell_id)
	# theres defo a better way to do this but it is what it is
	if spell_id == 0:
		# boo - instantly kill opponent
		if played_by == "Player":
			change_opponent_health(100)
			print("KILL ENEMY")
			return
		print("Kill me D:")
		change_player_health(100)
		return
		
	if spell_id == 3:
		# full moon - draw 3 creatures
		if played_by == "Player":
			print("you draw 3 creatures")
			emit_signal("player_draw", "creature")
			await get_tree().create_timer(0.5).timeout
			emit_signal("player_draw", "creature")
			await get_tree().create_timer(0.5).timeout
			emit_signal("player_draw", "creature")
			await get_tree().create_timer(0.5).timeout
			return
		print("opponent draws 3 creatures")
		emit_signal("opponent_draw", "creature")
		await get_tree().create_timer(0.1).timeout
		emit_signal("opponent_draw", "creature")
		await get_tree().create_timer(0.1).timeout
		emit_signal("opponent_draw", "creature")
		await get_tree().create_timer(0.1).timeout
	
	if spell_id == 6:
		# fire ball! - deal 6 to target
		if target == "Opponent":
			change_opponent_health(-6)
			return
		if target == "Player":
			change_player_health(-6)
			return
		target.update_stats(-6, 0)
	
	if spell_id == 7:
		# avalanche - deal 3 to all
		change_player_health(3)
		change_opponent_health(3)
		for creature in opponentCreatures:
			if creature != null:
				creature.update_stats(-3, 0)
		for creature in playerCreatures:
			if creature != null:
				creature.update_stats(-3, 0)
		return
	
	if spell_id == 9:
		# restore life - heal all friendly characters for 5
		if played_by == "Opponent":
			change_opponent_health(5)
			for creature in opponentCreatures:
				if creature != null:
					creature.update_stats(5, 0)
			return
			
		change_player_health(5)
		for creature in playerCreatures:
			if creature != null:
				creature.update_stats(5, 0)
		return
	
	if spell_id == 10:
		# scour tomes - draw 3 spells
		if played_by == "Player":
			print("you draw 3 spells")
			emit_signal("player_draw", "spell")
			await get_tree().create_timer(0.5).timeout
			emit_signal("player_draw", "spell")
			await get_tree().create_timer(0.5).timeout
			emit_signal("player_draw", "spell")
			await get_tree().create_timer(0.5).timeout
			return
		print("opponent draws 3 spells")
		emit_signal("opponent_draw", "spell")
		await get_tree().create_timer(0.1).timeout
		emit_signal("opponent_draw", "spell")
		await get_tree().create_timer(0.1).timeout
		emit_signal("opponent_draw", "spell")
		await get_tree().create_timer(0.1).timeout
		return
	
	if spell_id == 12:
		# stimpack - restore 10 health to target
		if target != "Opponent" and target != "Player":
			target.update_stats(10, 0)
			return
		if target == "Opponent":
			change_opponent_health(10)
			return
		change_player_health(10)
		
	if spell_id == 13:
		# interdimensional knowledge - draw 2 cards
		if played_by == "Player":
			print("you draw 2")
			emit_signal("player_draw", 0)
			await get_tree().create_timer(0.5).timeout
			emit_signal("player_draw", 0)
			await get_tree().create_timer(0.5).timeout
			return
		print("opponent draws 2")
		emit_signal("opponent_draw", 0)
		await get_tree().create_timer(0.1).timeout
		emit_signal("opponent_draw", 0)
		await get_tree().create_timer(0.1).timeout
		return
		
	if spell_id == 14:
		# laser volley - deal 4 damage to 2 random enemies
		var shotsLeft = 2
		var numTargets = 0
		for creature in opponentCreatures:
			if creature != null:
				numTargets += 1
				
		if numTargets == 1:
			for creature in opponentCreatures:
				if creature != null:
					creature.update_stats(-4, 0)
			change_opponent_health(4)
			return
			
		for creature in opponentCreatures:
			if (creature != null) and (shotsLeft > 0):
				if randf() <  (1/float(numTargets)):
					creature.update_stats(-4, 0)
					shotsLeft -= 1
				if shotsLeft == 0:
					return
		change_opponent_health(4)
		return
	
	if spell_id == 15:
		# let loose - give target 5 attack
		target.update_stats(0, 5)
		return
	
	if spell_id == 16:
		# curse - give creature -3 attack
		target.update_stats(0, -3)
		return
		
	print("spell not found")
		
