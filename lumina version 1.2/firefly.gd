extends Sprite2D
var GRAVITY = 15
var velY = 0
var JUMP_FORCE = -5  # Negative value for upward movement
var flyScale = scale
var MAX_ROTATION = 30.0  # Maximum rotation in degrees (both up and down)
var ROTATION_SPEED = 10.0  # How quickly the bird rotates

var collision_sound = preload("res://assests_g/hurt.wav")
var jump_sound = preload("res://assests_g/jump.wav")
var score_sound = preload("res://assests_g/score.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game started successfully!")
	z_index = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_over:	# getting game_over status from the root "Game" node.
		return
	velY += GRAVITY * delta
	position.y += velY
	var target_rotation = (velY / 10.0) * MAX_ROTATION  # Convert velocity to degrees
	target_rotation = clamp(target_rotation, -MAX_ROTATION, MAX_ROTATION)
	rotation_degrees = lerp(rotation_degrees, target_rotation, ROTATION_SPEED * delta)

func _input(event):
	if Global.game_over:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Apply upward impulse
		velY = JUMP_FORCE
	
		# Optional: Add a small animation effect when flapping
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0.8*flyScale.x, flyScale.y*1.2), 0.1)
		tween.tween_property(self, "scale", Vector2(flyScale.x, flyScale.y), 0.1)
		

#code for collision
func _on_fly_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "LowerArea2D" or area.name == "UpperArea2D" or area.name=="floorarea2d":
		if area.name == "floorarea2d": # only do this IF it hits the floor.
			position.y = get_viewport_rect().size.y - 25
		Global.game_over = true
		$"../Sounds/DeadSound".play()
		$"../GameOverTimer".start()
	

func _on_fly_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "GapArea2D":
		Global.score += 1
		
	

	
		
