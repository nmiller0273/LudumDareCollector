extends RichTextLabel

func _process(delta: float) -> void:
	text = ""
	for card in OpponentTurn.opponent_hand:
		text += card
		text += "\n"
