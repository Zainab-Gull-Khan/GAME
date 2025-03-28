extends Control
@onready var label = $CountDownLabel
@onready var timer = $CountDownTimer
@onready var sound = $CountdownSound
var count = 3		#countdown starting value
func _ready():
	label.text=str(count)	#initial countdown number
	sound.play()
	animate_text()
	timer.start()		#starting the timer

func animate_text():
	var tween = get_tree().create_tween()
	tween.tween_property(label, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(label, "scale", Vector2(1, 1), 0.2)

func _on_count_down_timer_timeout() -> void:
	count -=1
	if count>0:
		label.text = str(count)
		sound.play()
		animate_text()
		timer.start()  # Restart timer for next second
	else:
		get_tree().change_scene_to_file("res://scenes/game.tscn") 
		
