extends Control

func _ready():
	var tween = get_tree().create_tween()
	self.position = Vector2(0, -300)
	tween.tween_property(self, "position", Vector2(0, 0), 1)
	#self.position = Vector2(0, -300)

func on_win(winner):
	if winner == "Player":
		$Label.text = "You win this round!"
	else:
		$Label.text = "You Lose this round!"
	
	await get_tree().create_timer(3).timeout
	
	queue_free()
