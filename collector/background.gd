extends Node2D

var player_health = 15
var opponent_health = 15

func _ready():
	BoardState.opponent_takes_damage.connect(_on_opponent_takes_damage)
	BoardState.player_takes_damage.connect(_on_player_takes_damage)
	BoardState.game_start_signal.connect(_on_game_start)
	$playerIcon/damageSprite.modulate.a = 0
	$playerIcon/damageLabel.modulate.a = 0
	$opponentIcon/damageSprite.modulate.a = 0
	$opponentIcon/damageLabel.modulate.a = 0
	$playerIcon/healingSprite.modulate.a = 0
	$opponentIcon/healingSprite.modulate.a = 0
	
func _on_game_start():
	player_health = 15
	opponent_health = 15
	$playerIcon/hpLabel.text = str(player_health)
	$opponentIcon/hpLabel.text = str(opponent_health)	
	
func _on_player_takes_damage(damage):		
	player_health = player_health - damage
	$playerIcon/hpLabel.text = str(player_health)
	if damage > 0:
		$playerIcon/damageSprite.modulate = Color(1, 1-(float(damage) / 7.2), 0, 1)
		$playerIcon/damageLabel.modulate.a = 1
		$playerIcon/damageSprite.rotation = randi() % 360
		$playerIcon/damageSprite.scale = $playerIcon/damageSprite.scale * randf_range(0.8, 1.2)
		$playerIcon/damageLabel.text = str(damage)
		for k in range(20):
			await get_tree().create_timer(0.075).timeout
			$playerIcon/damageSprite.modulate.a -= 0.05
			$playerIcon/damageLabel.modulate.a  -= 0.05
	
	elif damage < 0:
		$playerIcon/healingSprite.modulate.a = 1
		$playerIcon/damageLabel.modulate.a = 1
		$playerIcon/healingSprite.rotation = randi_range(0, 90)
		$playerIcon/healingSprite.scale = $playerIcon/healingSprite.scale * randf_range(0.8, 1.2)
		$playerIcon/damageLabel.text = str(damage)
		for k in range(20):
			await get_tree().create_timer(0.075).timeout
			$playerIcon/healingSprite.modulate.a -= 0.05
			$playerIcon/damageLabel.modulate.a  -= 0.05
	
func _on_opponent_takes_damage(damage):
	opponent_health = opponent_health - damage
	$opponentIcon/hpLabel.text = str(opponent_health)
	if damage > 0:
		$opponentIcon/damageSprite.modulate = Color(1, 1-(float(damage) / 7.2), 0, 1)
		$opponentIcon/damageLabel.modulate.a = 1
		$opponentIcon/damageSprite.rotation = randi() % 360
		$opponentIcon/damageSprite.scale = $opponentIcon/damageSprite.scale * randf_range(0.8, 1.2)
		$opponentIcon/damageLabel.text = str(damage)
		for k in range(20):
			await get_tree().create_timer(0.075).timeout
			$opponentIcon/damageSprite.modulate.a -= 0.05
			$opponentIcon/damageLabel.modulate.a  -= 0.05
	
	elif damage < 0:
		$opponentIcon/healingSprite.modulate.a = 1
		$opponentIcon/damageLabel.modulate.a = 1
		$opponentIcon/healingSprite.rotation = randi_range(0, 90)
		$opponentIcon/healingSprite.scale = $opponentIcon/healingSprite.scale * randf_range(0.8, 1.2)
		$opponentIcon/damageLabel.text = str(damage)
		for k in range(20):
			await get_tree().create_timer(0.075).timeout
			$opponentIcon/healingSprite.modulate.a -= 0.05
			$opponentIcon/damageLabel.modulate.a  -= 0.05
