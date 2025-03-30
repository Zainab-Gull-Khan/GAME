extends Sprite2D

signal fruit_sliced

# Define the different types of fruits we can have
# Each fruit type has its own set of textures
enum FruitType {APPLE, BANANA, ORANGE, WATERMELON}

# Current fruit type and whether it's been sliced
var fruit_type = FruitType.APPLE
var is_sliced = false

# Physics properties for fruit movement
var velocity = Vector2.ZERO  # Current movement speed and direction
var gravity = 800.0         # How fast the fruit falls
var rotation_speed = 0.0    # How fast the fruit spins

# Dictionary to store all the textures for each fruit type
# Each fruit has three textures: whole fruit and two halves
var textures = {
	FruitType.APPLE: {
		"whole": preload("res://assets/images/apple_small.png"),
		"half1": preload("res://assets/images/apple_half_1_small.png"),
		"half2": preload("res://assets/images/apple_half_2_small.png")
	},
	FruitType.BANANA: {
		"whole": preload("res://assets/images/banana_small.png"),
		"half1": preload("res://assets/images/banana_half_1_small.png"),
		"half2": preload("res://assets/images/banana_half_2_small.png")
	},
	FruitType.ORANGE: {
		"whole": preload("res://assets/images/orange_small.png"),
		"half1": preload("res://assets/images/orange_half_1_small.png"),
		"half2": preload("res://assets/images/orange_half_2_small.png")
	},
	FruitType.WATERMELON: {
		"whole": preload("res://assets/images/watermelon_small.png"),
		"half1": preload("res://assets/images/watermelon_half_1_small.png"),
		"half2": preload("res://assets/images/watermelon_half_2_small.png")
	}
}

# Dictionary to store splash effect textures for each fruit type
# These are used when the fruit is sliced
# Splash textures based on fruit type
var splash_textures = {
	FruitType.APPLE: preload("res://assets/images/splash_red_small.png"),
	FruitType.BANANA: preload("res://assets/images/splash_yellow_small.png"),
	FruitType.ORANGE: preload("res://assets/images/splash_orange_small.png"),
	FruitType.WATERMELON: preload("res://assets/images/splash_red_small.png"),
}

# Preload the fruit piece scene
var FruitPiece = preload("res://scenes/fruit_piece.tscn")

func _ready():
	# Add to FRUIT group
	add_to_group("FRUIT")
	
	# Randomly select fruit type
	fruit_type = randi() % FruitType.size()
	texture = textures[fruit_type]["whole"]
	
	# Add random rotation
	rotation = randf_range(-PI/4, PI/4)
	rotation_speed = randf_range(-2, 2)
	
	# Set initial velocity (random x, upward y)
	velocity = Vector2(randf_range(-100, 100), -400)

func _process(delta):
	if not is_sliced:
		# Update position based on velocity
		position += velocity * delta
		
		# Apply gravity to velocity
		velocity.y += gravity * delta
		
		# Update rotation
		rotation += rotation_speed * delta
		
		# Remove if off screen
		if position.y > 800:
			queue_free()

func slice(slash_pos: Vector2):
	if is_sliced:
		return
	
	is_sliced = true
	emit_signal("fruit_sliced")
	
	# Create two halves
	var half1 = FruitPiece.instantiate()
	var half2 = FruitPiece.instantiate()
	
	half1.texture = textures[fruit_type]["half1"]
	half2.texture = textures[fruit_type]["half2"]
	
	get_parent().add_child(half1)
	get_parent().add_child(half2)
	
	# Position halves
	half1.position = position + Vector2(-10, 0)
	half2.position = position + Vector2(10, 0)
	
	# Set initial velocities for the pieces
	half1.velocity = Vector2(-100, -100)
	half2.velocity = Vector2(100, -100)
	
	# Create splash effect:
	create_splash_effect(slash_pos)
	
	# Remove original fruit
	queue_free()


func create_splash_effect(pos: Vector2):
	var splash = Sprite2D.new()
	splash.texture = splash_textures[fruit_type]

	# Add to root node (game scene), otherwise you won't see any effect at all.
	#   Why?
	get_parent().add_child(splash)
	
	# Use the mouse position directly
	splash.global_position = pos
	splash.scale = Vector2(0.5, 0.5)  # Start at normal size
	splash.modulate.a = 1.0
	splash.z_index = 100 
	
	# Animate splash
	var tween = splash.create_tween()
	tween.set_parallel(true)
	
	# Scale up quickly
	tween.tween_property(splash, "scale", Vector2(1.2, 1.2), 0.2)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	
	# Fade out
	tween.tween_property(splash, "modulate:a", 0.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)
	
	# Add rotation
	tween.tween_property(splash, "rotation", randf_range(-PI/2, PI/2), 0.3)\
		.set_trans(Tween.TRANS_SINE)
	
	# Move up and slightly outward
	var target_pos = splash.global_position + Vector2(randf_range(-10, 10), -30)
	tween.tween_property(splash, "global_position", target_pos, 0.3)\
		.set_trans(Tween.TRANS_SINE)
	
	# Connect to the finished signal to remove the splash when all tweens are done
	tween.finished.connect(func():
		splash.queue_free()
	)
