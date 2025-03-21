extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = get_viewport_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$ScoreLbl.text = "score: " + str(Global.score)

func _on_play_again_btn_pressed():
	#print("Play again clicked")
	var ready_scene = load("res://scenes/ready.tscn")
	get_tree().change_scene_to_packed(ready_scene)
	
