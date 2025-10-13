extends Button

var creature_combat = preload("res://creature_combat.gd")

signal draw_card_start_of_turn

func _pressed() -> void:
	var deck_instance = get_node("/root/BoardState")
	BoardState.player_dies.connect(_on_player_dies_signal)
	BoardState.opponent_dies.connect(_on_opponent_dies_signal)
	self.disabled = true
	var comb = creature_combat.new()
	add_child(comb)
	comb.combat_do("Player")
	await get_tree().create_timer(2).timeout
	$"../deck".opponent_draw()
	OpponentTurn.opponentTurnDo()
	await get_tree().create_timer(3).timeout
	comb.combat_do("Opponent")
	await get_tree().create_timer(3).timeout
	emit_signal("draw_card_start_of_turn")
	comb.queue_free()
	self.disabled = false

func _ready():
	release_focus()
	mouse_filter = Control.MOUSE_FILTER_PASS
	
func _on_player_dies_signal():
	queue_free()
	
func _on_opponent_dies_signal():
	queue_free()
