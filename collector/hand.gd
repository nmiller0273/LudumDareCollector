extends CharacterBody2D

@export var speed := 400.0

const hover_position = Vector2(650, 500)
const home_position = Vector2(650, 700)
var is_hovered = false

func _init():
	position = home_position

func _process(delta: float) -> void:
	if is_hovered == true:
		if position.distance_to(hover_position) > 2:
			var direction = (hover_position - position).normalized()
			velocity = direction * speed * (position.distance_to(hover_position))/100
		else:
			velocity = Vector2.ZERO
	else:		
		if position.distance_to(home_position) > 2:
			var direction = (home_position - position).normalized()
			velocity = direction * speed * (position.distance_to(home_position))/100
		else:
			velocity = Vector2.ZERO
	
	move_and_slide()

func _on_hand_area_mouse_entered() -> void:
	is_hovered = true

func _on_hand_area_mouse_exited() -> void:
	is_hovered = false
