extends Node2D

var draggingAny = false

func checkDraggingAny() -> bool:
	return draggingAny
	
func nowDragged():
	draggingAny = true

func noLongerDragged():
	draggingAny = false
