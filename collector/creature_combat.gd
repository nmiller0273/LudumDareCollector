extends Node

class_name CreatureCombat

func combat_do(player_turn: String):
	var creature_player = null
	var creature_opponent = null
	var card_player = null
	var card_opponent = null
	print("combat starts")
	for k in range(len(BoardState.opponentCreatures)):
		creature_opponent = BoardState.opponentCreatures[k]
		if creature_opponent != null:
			card_opponent = creature_opponent.get_node("cardOnBoard")
		creature_player = BoardState.playerCreatures[k]
		
		if creature_player != null:
			card_player = creature_player.get_node("cardOnBoard")
			print("null")
			
		if creature_player != null and creature_opponent != null:
			card_opponent.hit_target(card_player.id)
			card_player.hit_target(card_opponent.id)
			await get_tree().create_timer(0.25).timeout
			card_opponent.update_stats(-card_player.attack, 0)
			card_player.update_stats(-card_opponent.attack, 0)
			if card_opponent.health <= 0:
				BoardState.opponentCreatures[k] = null
			if card_player.health <= 0:
				BoardState.playerCreatures[k] = null
			await get_tree().create_timer(0.75).timeout
			
		elif (creature_player != null) and (player_turn == "Player"):
			card_player.hit_target("Opponent")
			BoardState.change_opponent_health(card_player.attack)
			await get_tree().create_timer(0.75).timeout
		elif (creature_opponent != null) and (player_turn == "Opponent"):
			card_opponent.hit_target("Player")
			BoardState.change_player_health(card_opponent.attack)
			await get_tree().create_timer(0.75).timeout
