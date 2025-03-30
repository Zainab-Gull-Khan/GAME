extends Node2D

# This script creates a visual trail effect when the player swipes their mouse
# It handles the trail animation, sound effects, and basic collision detection

# Store the last position of the mouse to calculate movement
var last_position = Vector2.ZERO

# The minimum distance the mouse needs to move to register as a slash
# This prevents accidental taps from being counted as slashes
var min_slash_distance = 10.0

# Arrays to store points for the slash trail and visual effect
var slash_points = []  # Stores all points of the current slash
var trail_points = []  # Stores points for the visual trail effect

# Maximum number of points to keep in the trail
# This prevents the trail from getting too long and using too much memory
const MAX_TRAIL_POINTS = 20

# Color and width settings for the slash trail
const TRAIL_COLOR = Color(0.2, 0.2, 0.2, 0.8)  # Dark gray with high opacity
const TRAIL_WIDTH = 8.0

# Different colors for each layer of the trail effect
# This creates a more dynamic and interesting visual effect
const TRAIL_COLORS = [
	Color(0.2, 0.2, 0.2, 0.8),  # Dark gray (main trail)
	Color(0.3, 0.3, 0.3, 0.6),  # Lighter gray (middle layer)
	Color(0.4, 0.4, 0.4, 0.4)   # Even lighter gray (outer layer)
]

# Sound effects for the swiping motion
# These will play randomly when the player starts a swipe
var swipe_sounds = [
	preload("res://assets/sounds/swipe1.wav"),
	preload("res://assets/sounds/swipe2.wav")
]

# Flag to track if the player is currently swiping
var is_swiping = false

## Called when the node is ready to be used
## Sets up the initial state of the slash trail
func _ready():
	# Make sure we're on top of everything
	z_index = 100

## Handles all input events (mouse clicks and movement)
## Creates the trail effect and checks for collisions
func _input(event):
	# Handle mouse button events
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:  # Left mouse button
			if event.pressed:  # When button is first pressed
				# Start a new swipe
				is_swiping = true
				play_swipe_sound()  # Play a random swipe sound
			else:  # When button is released
				# End the swipe
				is_swiping = false
				trail_points.clear()  # Clear the trail points
				queue_redraw()  # Update the visual display
	
	# Handle mouse movement events
	elif event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT and is_swiping:
			# Record the slash point
			slash_points.append(event.position)
			
			# Add to trail points for visual effect
			trail_points.append(event.position)
			# Keep the trail from getting too long
			if trail_points.size() > MAX_TRAIL_POINTS:
				trail_points.pop_front()  # Remove the oldest point
			
			# Check if we hit any fruits
			check_slice(event.position)
			
			# Create the visual trail effect
			create_slash_trail(event.position)
			
			last_position = event.position
			
			# Update the visual display
			queue_redraw()

## Plays a random swipe sound effect
## Creates a temporary audio player that removes itself when done
func play_swipe_sound():
	# Create a new audio player for the swipe sound
	var audio = AudioStreamPlayer.new()
	# Choose a random swipe sound
	audio.stream = swipe_sounds[randi() % swipe_sounds.size()]
	audio.volume_db = -10  # Make the sound slightly quieter
	add_child(audio)
	audio.play()
	
	# Wait for the sound to finish playing
	await audio.finished
	# Remove the audio player to free up memory
	audio.queue_free()

## Draws the trail effect on screen
## Creates a multi-layered trail that changes based on movement speed
func _draw():
	# Only draw the trail if we have at least 2 points
	if trail_points.size() > 1:
		# Calculate how fast the mouse is moving at each point
		var velocities = []
		for i in range(trail_points.size()):
			if i == 0:  # First point
				velocities.append((trail_points[1] - trail_points[0]).length())
			elif i == trail_points.size() - 1:  # Last point
				velocities.append((trail_points[i] - trail_points[i-1]).length())
			else:  # Middle points
				# Average the speed between previous and next point
				var prev_vel = (trail_points[i] - trail_points[i-1]).length()
				var next_vel = (trail_points[i+1] - trail_points[i]).length()
				velocities.append((prev_vel + next_vel) / 2)
		
		# Find the fastest movement for scaling
		var max_velocity = velocities.max()
		
		# Draw multiple layers of the trail for a more dynamic effect
		for layer in range(3):
			for i in range(trail_points.size() - 1):
				var start = trail_points[i]
				var end = trail_points[i + 1]
				
				# Make the trail fade out towards the end
				var alpha = float(i) / trail_points.size()
				var color = TRAIL_COLORS[layer]
				color.a = alpha * (1.0 - float(layer) * 0.2)  # Each layer is more transparent
				
				# Make the trail wider when moving faster
				var normalized_velocity = velocities[i] / max_velocity
				var base_width = TRAIL_WIDTH * (1.0 + float(layer) * 0.5)
				var velocity_factor = 0.5 + normalized_velocity * 0.5  # Scale between 0.5 and 1.0
				var width = base_width * velocity_factor
				
				# Make the trail thinner at the start and end
				var taper_factor = 1.0
				if i < 3:  # Start taper
					taper_factor = float(i) / 3.0
				elif i > trail_points.size() - 4:  # End taper
					taper_factor = float(trail_points.size() - i) / 3.0
				
				width *= taper_factor
				
				# Draw the line segment
				draw_line(start, end, color, width)
				
				# Add a subtle glow effect for the outer layer
				if layer == 2:
					var glow_color = Color(0.5, 0.5, 0.5, alpha * 0.2)
					draw_line(start, end, glow_color, width * 1.5)

## Checks if the current slash position hits any fruits
## If a fruit is hit, it will be sliced
func check_slice(pos: Vector2):
	# Get all fruits currently in the game
	var fruits = get_tree().get_nodes_in_group("FRUIT")
	
	# Check each fruit for collision
	for fruit in fruits:
		if not fruit.is_sliced:  # Only check unsliced fruits
			# Calculate distance between slash point and fruit
			var distance = pos.distance_to(fruit.position)
			# If we're close enough to the fruit, slice it
			if distance < 50:  # 50 pixels is the slice detection radius
				fruit.slice(pos)  # Tell the fruit it was sliced

## Creates a temporary visual effect for each slash
## The effect grows, fades out, and then removes itself
func create_slash_trail(pos: Vector2):
	# Create a line to show the slash
	var line = Line2D.new()
	line.width = TRAIL_WIDTH
	line.default_color = TRAIL_COLOR
	add_child(line)
	
	# Add points to the line
	if slash_points.size() > 1:
		line.points = slash_points
	
	# Create an animation for the slash effect
	var tween = create_tween()
	tween.set_parallel(true)  # Run all animations at the same time
	
	# Make the slash grow slightly
	tween.tween_property(line, "scale", Vector2(1.2, 1.2), 0.2)\
		.from(Vector2(1, 1))\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	
	# Make the slash fade out
	tween.tween_property(line, "modulate:a", 0.0, 0.3)\
		.from(0.8)\
		.set_trans(Tween.TRANS_SINE)
	
	# Add a slight random rotation
	tween.tween_property(line, "rotation", randf_range(-0.1, 0.1), 0.2)\
		.from(0)\
		.set_trans(Tween.TRANS_SINE)
	
	# Remove the line after the animation is done
	tween.tween_callback(line.queue_free)
