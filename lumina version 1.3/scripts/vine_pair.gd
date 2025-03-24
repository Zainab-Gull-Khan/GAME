extends Node2D

var GAP = 200
var VINE_SCROLL_SPEED = 100


func getLowerY():
	return $Lower.position.y

func getUpperY():
	return $Upper.position.y


func _ready():
	pass


func _process(delta):
	if Global.game_over:
		return
	var gap_offset = 50  # Increase this value to make the gap larger
	
	$Upper.position.y = -GAP/2.0 - gap_offset
	$Lower.position.y = GAP/2.0 + gap_offset
	position.x -= VINE_SCROLL_SPEED * delta



func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Exited screen") # Replace with function body.
	queue_free()
