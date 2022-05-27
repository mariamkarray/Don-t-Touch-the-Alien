extends Node

# A simplified interface to a scene file. 
# Provides access to operations and checks that can be performed on the scene resource itself. 

export (PackedScene) var enemyScene
# score is updated every second
var score = 0

func _ready():
	# without randomize(), the randf() chooses the same "random" number everytime.
	randomize()
	
func new_game():
	score = 0
	$HeadsUpDisplay.update_score(score)
	
	# make an object of the already made group of enemies
	# we're now making them dissapear as a whole on command
	get_tree().call_group("enemies", "queue_free")
	$Player.start($startPosition.position)
	
	# start the timer
	$StartTimer.start()
	$music.play()
	
	$HeadsUpDisplay.show_message("Remember, stay away..")
	# yield makes godot read through all the code, stop at yeild and wait for a signal to emit
	# wait until the timer times out
	# start timer delays the spawn of enemies
	# just when the timer (1 sec) times out, we'll start the enemies and score updates
	yield($StartTimer, "timeout")
	# start the score timer
	$ScoreTimer.start()
	$EnemyTimer.start()
	
	
func game_over():
	$ScoreTimer.stop()	
	$EnemyTimer.stop()
	$HeadsUpDisplay.show_game_over()
	$music.stop()
	$gameOverMusic.play()
func _on_EnemyTimer_timeout():
	# first we'll get a random location to spawn the enemy
	# then create an instance of the enemy and place it at this location
	# finally we'll set its velocity to move towards the player
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation # store location in a variable
	enemy_spawn_location.unit_offset = randf() # location offset is set to a random float
	
	var enemy = enemyScene.instance()
	add_child(enemy)
	
	# the following code randomizes the starting position of the enemy
	# but it doesn't move it
	enemy.position = enemy_spawn_location.position
	
	# rotate it by 90 degrees so it rotates and is not stuck on the boundaries of the rectangle
	var direction = enemy_spawn_location.rotation + PI / 2
	direction += rand_range(- PI / 4, PI / 4) # offset direction randomly
	
	# randomize the velocity
	# this vector points to the right
	var velocity = Vector2(rand_range(enemy.minSpeed, enemy.maxSpeed), 0)
	enemy.linear_velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score+=1
	$HeadsUpDisplay.update_score(score)
	
