extends Node2D

var bg
var BG_SCROLL_SPEED = 30


# Called when the node enters the scene tree for the first time.
func _ready():
	bg = $Bg
	# Reset some global values
	Global.score = 0
	Global.game_over = false
	
	# insert the background music
	
	# Wait briefly before proceeding:
	await get_tree().create_timer(0.5).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bg.position.x -= BG_SCROLL_SPEED * delta
	if bg.position.x < -575:
		bg.position.x = 0


func _on_button_pressed():
	Global.bg_position = bg.position
	var ready_scene = load("res://scenes/ready.tscn")
	get_tree().change_scene_to_packed(ready_scene)


func _on_button_2_pressed() -> void:
	get_tree().quit()
