extends Sprite2D

var character_name: String

func set_card_display(name: String):
	character_name = name
	var file_name = "res://sprites/board" + character_name + ".png"
	texture = load(file_name)
	self.scale = Vector2(219.0, 291.0) / texture.get_size()
