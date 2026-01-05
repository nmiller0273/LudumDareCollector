extends Node2D

var id = ""
var health = 1
var attack = 1
var creature_played_by = ""
signal creature_add_to_deck(creature_id, target_player)

func setup(value: String, loc: int, playedBy: String) -> void:
	$damageSprite.modulate.a = 0
	$damageLabel.modulate.a = 0
	$healingSprite.modulate.a = 0
	creature_played_by = playedBy
	id = value
	$creatureSprite.set_card_display(id)	
	var stat_file_name = "res://creature_stats/" + id + ".tres"
	var creature_stats
	creature_stats = load(stat_file_name).duplicate()
	health = creature_stats.health
	attack = creature_stats.attack
	$attackLabel.text = str(attack)
	$hpLabel.text = str(health)
	if playedBy == "Player":
		position = Vector2(375, (125 + (loc * 150)))
	else:
		position = Vector2(777, (125 + (loc * 150)))
		
func die():
	# add to opponents deck
	emit_signal("creature_add_to_deck", id, creature_played_by)
	queue_free()

func update_stats(healthChange: int, attackChange: int):
	health = health + healthChange
	attack = attack + attackChange
	$attackLabel.text = str(attack)
	$hpLabel.text = str(health)
	if healthChange < 0:
		$damageSprite.modulate = Color(1, 1-(float(-healthChange) / 7.2), 0, 1)
		$damageLabel.modulate.a = 1
		$damageSprite.rotation = randi() % 360
		$damageSprite.scale = $damageSprite.scale * randf_range(0.8, 1.2)
		$damageLabel.text = str(healthChange)
		for k in range(20):
			await get_tree().create_timer(0.075).timeout
			$damageSprite.modulate.a -= 0.05
			$damageLabel.modulate.a  -= 0.05
	
	elif healthChange > 0:
		$healingSprite.modulate.a = 1
		$damageLabel.modulate.a = 1
		$healingSprite.rotation = randi_range(0, 90)
		$healingSprite.scale = $healingSprite.scale * randf_range(0.8, 1.2)
		$damageLabel.text = str(healthChange)
		for k in range(20):
			await get_tree().create_timer(0.075).timeout
			$healingSprite.modulate.a -= 0.05
			$damageLabel.modulate.a  -= 0.05
			
	if health <= 0:
		die()
	
func hit_target(enemy: String):
	var destination = Vector2(0,0)
	if enemy == "Opponent":
		destination = Vector2(500,0)
	elif enemy == "Player":
		destination = Vector2(-500,0)
	elif creature_played_by == "Player":
		destination = Vector2(200,0)
	else:
		destination = Vector2(-200,0)
	var start_position = position
	var target_position = position + destination
	var timer = 0.0
	if enemy == "Opponent" or enemy == "Player":
		target_position.y = 200
	while timer < 0.25:
		var t = timer / 0.25
		position = start_position.lerp(target_position, t)
		timer += get_process_delta_time()
		if destination[0] > 0:
			self.rotation += 0.01
		else:
			self.rotation -= 0.01
		await get_tree().process_frame
	timer = 0.0
	while timer < 0.25:
		var t = timer / 0.25
		position = target_position.lerp(start_position, t)
		if destination[0] > 0:
			self.rotation -= 0.01
		else:
			self.rotation += 0.01
		timer += get_process_delta_time()
		await get_tree().process_frame
	position = start_position
	self.rotation = 0
	
	
