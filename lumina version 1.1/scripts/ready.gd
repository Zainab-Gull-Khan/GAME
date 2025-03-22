extends Node2D

var bg
var firefly
var BG_SCROLL_SPEED = 30

var count = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	bg = $Bg
	bg.position = Global.bg_position
	firefly = $fly
	var size = get_viewport_rect().size
	firefly.position = Vector2(size.x/2, size.y/2)
	
	
	# Reset some global values
	Global.score = 0
	Global.game_over = false
	
	$TimerAudio.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var lbl = $timerLabel
	lbl.text = str(count)
	if count <= 0:
		Global.bg_position = bg.position
		var game_scene = load("res://scenes/game.tscn")
		get_tree().change_scene_to_packed(game_scene)
		
	bg.position.x -= BG_SCROLL_SPEED * delta
	if bg.position.x < -575:
		bg.position.x = 0
	
func _on_ready_timer_timeout():
	count -= 1
	if count >= 1:
		$TimerAudio.play()
	
	
