extends Control

var game_start = preload("res://handAndDecks.tscn")

func _on_start_game_button_button_up() -> void:
	var sendOff = []
	if $wizardCheck.button_pressed:
		sendOff.append("wizards")
	if $halloweenCheck.button_pressed:
		sendOff.append("halloween")
	print(sendOff)
	var game_played_instance = game_start.instantiate()
	get_tree().root.add_child(game_played_instance)
	game_played_instance.get_node("deck").first_time_setup(sendOff)
	queue_free()
