extends Node2D

var bg
var fly
var BG_SCROLL_SPEED = 30

var pipe_scene = preload("res://scenes/pipe_pair.tscn")

var prevY
var PIPE_OFFSET = 150
var GAP = 200

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	bg = $Bg
	bg.position = Global.bg_position
	bg.z_index = -10 
	fly = $firefly
	var size = get_viewport_rect().size
	fly.position = Vector2(size.x/2, size.y/2)
	prevY = get_viewport().size.y/2
	
	

func _process(delta):
	if Global.game_over:
		return
		
	# background logic
	bg.position.x -= BG_SCROLL_SPEED * delta
	if bg.position.x < -575:
		bg.position.x = 0

	
	$ScoreLbl.text = "score: " + str(Global.score)
	


func _on_pipe_timer_timeout():
	var screen_width = get_viewport().size.x
	var screen_height = get_viewport().size.y
	
	# Create a new pipe pair instance
	var pipe = pipe_scene.instantiate()
	# Position the pipe at the right edge of the screen
	pipe.position.x = screen_width + 30  # Add extra space so it appears off-screen
	pipe.GAP = GAP
	pipe.position.y = randf_range(prevY - PIPE_OFFSET, prevY + PIPE_OFFSET)
	if pipe.getLowerPipeY() > screen_height - 20:
		pipe.position.y = screen_height - 20 - GAP
	if pipe.getUpperPipeY() < 20:
		pipe.position.y = 20 + GAP
	
	prevY = pipe.position.y
	
	# Set a negative z-index to render behind other elements
	pipe.z_index = -1
	
	# Add the pipe to your game scene
	add_child(pipe)


func _on_game_over_timer_timeout():
	var game_over_scene = load("res://scenes/game_over.tscn")
	get_tree().change_scene_to_packed(game_over_scene)


func _on_challenge_timer_timeout():
	GAP -= 20
	PIPE_OFFSET += 5
	$PipeTimer.wait_time -= 0.3
	clamp($PipeTimer.wait_time, 0.75, 2.5)
	
