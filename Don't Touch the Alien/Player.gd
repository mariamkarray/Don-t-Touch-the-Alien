extends Area2D
# know when a player is hit with something
signal hit

# export keyword is for making the player's variables editable in the inspector
export var speed = 400.0
var screenSize = Vector2.ZERO
# limit screen size
func _ready():
	screenSize = get_viewport_rect().size # get value of the screen x and y
	hide() # hide at the player start of the game
	
# calulating the player's direction vector
func _process(delta):
	var direction = Vector2.ZERO # equivelant to Vector (0,0)
	if Input.is_action_pressed("move_right"):
		direction.x += 1;
	if	Input.is_action_pressed("move_left"):
		direction.x -= 1;
	if Input.is_action_pressed("move_up"):
		direction.y -= 1;
	if	Input.is_action_pressed("move_down"):
		direction.y += 1;

# this function is called when a user presses at least one key (one or more, doesnt matter)
# when you move diagonally (ex: right and up) the vector will be greater than 1
# and the player will be faster and we dont want this bug
	if direction.length() > 0:
		# ensure the player moves in constant speed regardless of the direction
		direction = direction.normalized()
		$AnimatedSprite.play() # animate
	else:
		$AnimatedSprite.stop()
		
		
	# 	how to move the area node
	position += direction * speed * delta
	# clamp() limits player position
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
	# means that the player is pressing left or right
	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false # dont flip the sprite vertically when moving horizontally
		# direction.x < 0 is true when we move to the left
		$AnimatedSprite.flip_h = direction.x < 0 # the player is moving to the left so we flip the sprite
	# the player is moving horizontally (up or down)
	elif direction.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
# initalize the player
func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

# detects bodies entering the player
func _on_Player_body_entered(body):
	# hide the node
	hide()
	# deactivate its collision
	$CollisionShape2D.set_deferred("disabled", true)
	#  allow a node to send out a message that other nodes can listen for and respond to
	emit_signal("hit")
