extends Node2D

var GAP = 200
var PIPE_SCROLL_SPEED = 100
# Called when the node enters the scene tree for the first time.

func getLowerPipeY():
	return $PipeLower.position.y

func getUpperPipeY():
	return $PipeUpper.position.y


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_over:
		return
		
	$PipeUpper.position.y = -GAP/2.0
	$PipeLower.position.y = GAP/2.0
	
	position.x -= PIPE_SCROLL_SPEED * delta
	

#func _input(event):
	## Check for left mouse button click
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		## Apply upward impulse
		#GAP += 10


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Exited screen") # Replace with function body.
	queue_free()
