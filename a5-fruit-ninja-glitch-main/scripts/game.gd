extends Node2D

# This is the main game script that handles:
# - Spawning fruits
# - Keeping track of score
# - Managing game state
# - Creating visual effects

# Constants for game configuration
const SPAWN_INTERVAL = 2.0  # How often new fruits appear (in seconds)
const MIN_SPAWN_X = 50		# Leftmost position where fruits can spawn
const MAX_SPAWN_X = 350		# Rightmost position where fruits can spawn
const SPAWN_Y = 700			# Y position where fruits spawn (bottom of screen)

# Initial velocity ranges for fruits
const INITIAL_Y_VELOCITY = -900  # How fast fruits shoot upward
const INITIAL_X_VELOCITY_RANGE = Vector2(-10, 10)  # Random left/right movement

# Preload the fruit scene so we can create new fruits
var Fruit = preload("res://scenes/fruit.tscn")

# Game state variables
var score = 0              # Current game score
var is_game_active = true  # Whether the game is currently running
var time = 0.0             # Time elapsed in the game

## Called when the game starts
## Sets up the initial game state and starts spawning fruits
func _ready():
	# Start spawning fruits
	spawn_fruit()
	$SpawnTimer.wait_time = SPAWN_INTERVAL
	$SpawnTimer.start()
	
	# Setup background (currently commented out)
	#$Background.texture = preload("res://assets/images/background.png")

## Called every frame
## Updates game time and other time-based elements
func _process(delta):
	if is_game_active:
		time += delta
		#$TimeLabel.text = "Time: %.1f" % time  # Currently commented out

## Creates a new fruit and adds it to the game
## Sets up the fruit's initial position, rotation, and movement
func spawn_fruit():
	if not is_game_active:
		return
		
	# Create a new fruit instance
	var fruit = Fruit.instantiate()
	add_child(fruit)
	
	# Connect to the fruit_sliced signal to update score
	fruit.fruit_sliced.connect(_on_fruit_sliced)
	
	# Random spawn position
	var spawn_x = randf_range(MIN_SPAWN_X, MAX_SPAWN_X)
	fruit.position = Vector2(spawn_x, SPAWN_Y)
	
	# Random rotation and rotation speed
	fruit.rotation = randf_range(-PI/4, PI/4)
	fruit.rotation_speed = randf_range(-10, 10)
	
	# Set initial velocity (random x, upward y)
	fruit.velocity = Vector2(
		randf_range(INITIAL_X_VELOCITY_RANGE.x, INITIAL_X_VELOCITY_RANGE.y),
		INITIAL_Y_VELOCITY
	)
	
	# Create a scale-up animation for the fruit
	var tween = create_tween()
	tween.tween_property(fruit, "scale", Vector2(1, 1), 0.3)\
		.from(Vector2(0.1, 0.1))\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)

## Called when the spawn timer triggers
## Creates a new fruit at regular intervals
func _on_spawn_timer_timeout():
	spawn_fruit()

## Called when a fruit is sliced
## Updates the score and creates a visual effect
func _on_fruit_sliced():
	score += 10
	$ScoreLabel.text = "Score: %d" % score
	
	# Create a popup animation showing the points earned
	score_popup(get_global_mouse_position())

## Creates a visual popup showing points earned
## The popup appears where the fruit was sliced and floats upward
func score_popup(pos: Vector2):
	# Create a new label for the popup
	var popup = Label.new()
	popup.text = "+10"
	popup.add_theme_font_size_override("font_size", 32)
	popup.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	popup.z_index = 1000  # Make sure it appears above everything
	
	add_child(popup)
		
	# Set initial position and properties
	popup.global_position = pos
	popup.scale = Vector2(0.1, 0.1)  # Start very small
	popup.modulate.a = 1.0  # Start fully visible
	
	# Create an animation for the popup
	var tween = popup.create_tween()
	
	# Make the popup grow with a bounce effect
	tween.tween_property(popup, "scale", Vector2(1.0, 1.0), 1)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	
	# Move the popup upward
	var target_pos = popup.global_position + Vector2(0, -30)
	tween.parallel().tween_property(popup, "global_position", target_pos, 0.5)\
		.set_trans(Tween.TRANS_SINE)
	
	# Make the popup fade out
	tween.tween_property(popup, "modulate:a", 0.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)
	
	# Remove the popup when the animation is done
	tween.finished.connect(func():
		popup.queue_free()
	) 
