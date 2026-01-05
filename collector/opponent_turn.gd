extends Node

var opponent_hand = []
var opponent_hand_type = []
var played_cards = 0

func opponentTurnDo():
	played_cards = 0
	for creature in BoardState.opponentCreatures:
		if creature == null:
			for k in range(len(opponent_hand)):
				if opponent_hand_type[k] == "Creature":
					played_cards += 1
					BoardState.processCard(opponent_hand[k], "Opponent")
					opponent_hand_type.pop_at(k)
					opponent_hand.pop_at(k)
					await get_tree().create_timer(0.75).timeout
					break
	
	if played_cards == 3:
		return
	
	for k in range(len(opponent_hand)):
		if opponent_hand_type[k] == "Spell":
			played_cards += 1
			# play the spell
			if played_cards == 3:
				return
	
	return

func _on_opponent_draw(id):
	opponent_hand.append(id)
	if ResourceLoader.exists("res://creature_stats/" + id + ".tres"):
		opponent_hand_type.append("Creature")
		return
	opponent_hand_type.append("Spell")
