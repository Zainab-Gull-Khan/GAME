extends Node2D
var bg
var BG_SCROLL_SPEED = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	bg = $Bg
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bg.position.x -= BG_SCROLL_SPEED * delta
	if bg.position.x < -575:
		bg.position.x = 0
	$ScoreLbl.text = "score: " + str(Global.score)

func _on_play_again_btn_pressed():
	#print("Play again clicked")
	var ready_scene = load("res://scenes/ready.tscn")
	get_tree().change_scene_to_packed(ready_scene)
	
