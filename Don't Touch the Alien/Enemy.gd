extends RigidBody2D

export var minSpeed = 150.0
export var maxSpeed = 250.0

# change the monster's look randomly
func _ready():
	# if true, the animation is currently playing
	$AnimatedSprite.playing = true
	# list of animation names (fly, swim, walk)
	# frame proprty contains the animation
	var enemyTypes = $AnimatedSprite.frames.get_animation_names() # this is an array ["fly", "walk",..]
	# generate a random animation
	# we use mod the size since the rand() will return large numbers and we only have 3 animations in the list
	$AnimatedSprite.animation = enemyTypes[randi() % enemyTypes.size()]

# function called when the enemy exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	# free the enemy from memory when it exits the screen
	queue_free()
