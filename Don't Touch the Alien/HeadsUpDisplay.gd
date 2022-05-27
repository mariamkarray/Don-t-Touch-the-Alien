extends CanvasLayer

# is emitted when the player presses the start button
signal startGame

# update the score label
func update_score(score):
	$ScoreLabel.text = str(score)
	
# displaying other texts for the player
# when the player starts the game, this text will show for a specific time, then it will dissappear
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game Over")
	# the code will stop here until message timer executes timeout signal
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Again, STAY away."
	$MessageLabel.show()
	
	# wait for 1 second without an explicit timer
	yield(get_tree().create_timer(1.0), "timeout")
	$Button.show()
func _on_Button_pressed():
	$Button.hide()
	emit_signal("startGame")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
