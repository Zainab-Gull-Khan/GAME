extends Sprite2D

var velocity = Vector2.ZERO
var gravity = 800.0
var rotation_speed = 0.0

func _ready():
	# Add random rotation
	rotation = randf_range(-PI/4, PI/4)
	rotation_speed = randf_range(-2, 2)

func _process(delta):
	# Update position based on velocity
	position += velocity * delta
	
	# Apply gravity to velocity
	velocity.y += gravity * delta
	
	# Update rotation
	rotation += rotation_speed * delta
	
	# Remove if off screen
	if position.y > 800:
		queue_free() 