extends Button

var creature_combat = preload("res://creature_combat.gd")

signal draw_card_start_of_turn

var game_ended = false

func _pressed() -> void:
	BoardState.player_dies.connect(_on_player_dies_signal)
	BoardState.opponent_dies.connect(_on_opponent_dies_signal)
	self.disabled = true
	self.visible = false
	var comb = creature_combat.new()
	add_child(comb)
	comb.combat_do("Player")
	await get_tree().create_timer(2).timeout
	if self.game_ended == false:
		$"../deck".opponent_draw()
		OpponentTurn.opponentTurnDo()
		await get_tree().create_timer(3).timeout
		comb.combat_do("Opponent")
		await get_tree().create_timer(3).timeout
		emit_signal("draw_card_start_of_turn")
		comb.queue_free()
		self.disabled = false
		self.visible = true

func _ready():
	release_focus()
	mouse_filter = Control.MOUSE_FILTER_PASS
	
func _on_player_dies_signal():
	self.game_ended = true
	self.disabled = true
	self.visible = false
	await get_tree().create_timer(8).timeout
	self.visible = true
	self.game_ended = false
	self.disabled = false
	
func _on_opponent_dies_signal():
	self.game_ended = true
	self.disabled = true
	self.visible = false
	await get_tree().create_timer(8).timeout
	self.visible = true
	self.game_ended = false
	self.disabled = false
