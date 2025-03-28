extends Node2D

# Constants for game configuration
const SPAWN_INTERVAL = 2.0
const MIN_SPAWN_X = 50
const MAX_SPAWN_X = 350
const SPAWN_Y = 700

const INITIAL_Y_VELOCITY = -900
const INITIAL_X_VELOCITY_RANGE = Vector2(-10, 10)

var Fruit = preload("res://scenes/fruit.tscn")

# Game state variables
var score = 0
var is_game_active = true
var time = 0.0
var time_left = 15
var bobbing_tween = null  # Tween for bobbing effect

@onready var countdown_label = $countdown_Label
@onready var countdown_timer = $countdown_Timer
@onready var ticking_sound = $TickingAudio

func _ready():
	spawn_fruit()
	$SpawnTimer.wait_time = SPAWN_INTERVAL
	$SpawnTimer.start()

	# Initialize countdown timer
	countdown_label.text = str(time_left)
	countdown_timer.wait_time = 1.0
	countdown_timer.start()
	countdown_timer.timeout.connect(_on_countdown_timer_timeout)

func _process(delta):
	if is_game_active:
		time += delta
		update_timer_effects()

func _on_countdown_timer_timeout():
	if time_left > 0:
		time_left -= 1
		countdown_label.text = str(time_left)
		
		# Play ticking sound and start bobbing effect in last 10 seconds
		if time_left <= 10:
			ticking_sound.play()
			start_bobbing_effect()

	if time_left == 0:
		game_over()

func update_timer_effects():
	var color = Color(1, 1, 1)  # Default white

	if time_left <= 10:
		color = Color(1, 0, 0)  # Red

	# Update font fill color directly
	countdown_label.add_theme_color_override("font_color", color)

func start_bobbing_effect():
	if bobbing_tween:
		bobbing_tween.kill()  # Stop any previous tween
	
	bobbing_tween = get_tree().create_tween()
	var original_pos = countdown_label.position
	var bob_offset = Vector2(3, -3)  # Moves 3 pixels up and down

	bobbing_tween.tween_property(countdown_label, "position", original_pos + bob_offset, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bobbing_tween.tween_property(countdown_label, "position", original_pos, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bobbing_tween.set_loops()  # Keep looping until stopped

func game_over():
	is_game_active = false
	$SpawnTimer.stop()
	countdown_timer.stop()

	if bobbing_tween:
		bobbing_tween.kill()  # Stop bobbing effect on game over

	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func spawn_fruit():
	if not is_game_active:
		return

	var fruit = Fruit.instantiate()
	add_child(fruit)

	fruit.fruit_sliced.connect(_on_fruit_sliced)

	var spawn_x = randf_range(MIN_SPAWN_X, MAX_SPAWN_X)
	fruit.position = Vector2(spawn_x, SPAWN_Y)

	fruit.rotation = randf_range(-PI / 4, PI / 4)
	fruit.rotation_speed = randf_range(-10, 10)

	fruit.velocity = Vector2(
		randf_range(INITIAL_X_VELOCITY_RANGE.x, INITIAL_X_VELOCITY_RANGE.y),
		INITIAL_Y_VELOCITY
	)

	var tween = create_tween()
	tween.tween_property(fruit, "scale", Vector2(1, 1), 0.3)\
		.from(Vector2(0.1, 0.1))\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)

func _on_spawn_timer_timeout():
	spawn_fruit()

func _on_fruit_sliced():
	score += 10
	$ScoreLabel.text = "Score: %d" % score
	score_popup(get_global_mouse_position())

func score_popup(pos: Vector2):
	var popup = Label.new()
	popup.text = "+10"
	popup.add_theme_font_size_override("font_size", 32)
	popup.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	popup.z_index = 1000

	add_child(popup)

	popup.global_position = pos
	popup.scale = Vector2(0.1, 0.1)
	popup.modulate.a = 1.0

	var tween = popup.create_tween()
	tween.tween_property(popup, "scale", Vector2(1.0, 1.0), 1)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)

	var target_pos = popup.global_position + Vector2(0, -30)
	tween.parallel().tween_property(popup, "global_position", target_pos, 0.5)\
		.set_trans(Tween.TRANS_SINE)

	tween.tween_property(popup, "modulate:a", 0.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)

	tween.finished.connect(func(): popup.queue_free())
