extends "MoveObject.gd"

signal collision(velocity)
signal hurt(velocity, pos)

export(bool) var CONTACT_FEEDBACK = false 
export(bool) var EYE = false

# TODO : Check if unhandeled_input better
func _input(event):
	if(event.is_action_pressed("ui_left")):
		input_dir.x -= 1.0
	elif(event.is_action_pressed("ui_right")):
		input_dir.x += 1.0
	elif(event.is_action_pressed("ui_up")):
		input_dir.y -= 1.0
	elif(event.is_action_pressed("ui_down")):
		input_dir.y += 1.0
	elif(event.is_action_released("ui_left")):
		input_dir.x += 1.0
	elif(event.is_action_released("ui_right")):
		input_dir.x -= 1.0
	elif(event.is_action_released("ui_up")):
		input_dir.y += 1.0
	elif(event.is_action_released("ui_down")):
		input_dir.y -= 1.0
	# Do not normalize input_dir !

func _process(delta):
	update()

# Draw
func _draw():
	draw_circle(Vector2(0.0, 0.0), $CollisionShape2D.shape.radius, Color(0.25, 0.5, 0.25))
	if EYE:
		var vect = Vector2(0.0, 0.0)
		var d = 10000000
		for m in get_tree().get_nodes_in_group("mob"):
			var vect_test = (m.global_position - global_position)
			var d_test = vect_test.length()
			if d_test < d:
				vect = vect_test
				d = d_test
		draw_circle(vect.normalized() * $CollisionShape2D.shape.radius * 0.5, $CollisionShape2D.shape.radius * 0.5, Color(0.7, 0.7, 0.35))
		draw_circle(vect.normalized() * ($CollisionShape2D.shape.radius* 0.7), $CollisionShape2D.shape.radius * 0.2, Color(1.0, 1.0, 1.0))
		
func _on_Player_body_entered(body):
	# Managing signals
	emit_signal("collision", linear_velocity)
	if body.is_in_group("mob"):
		emit_signal("hurt", (linear_velocity - body.linear_velocity).length(), (global_position + body.global_position)/2.0)		
	# Manging contact feedback
	if(CONTACT_FEEDBACK):
		var rand_color = Color()
		if body.is_in_group("mob"):
			rand_color = Color(rand_range(0.5, 1.0), rand_range(0.0, 0.5), rand_range(0.0, 0.2))
		else:
			rand_color = Color(rand_range(0.0, 0.0), rand_range(0.0, 0.5), rand_range(0.5, 1.0))
		var duration = 0.2
		$Tween.stop_all()
		$Tween.interpolate_property(self, 
				"modulate", Color(1.0, 1.0, 1.0), 
				rand_color, duration, Tween.TRANS_CUBIC, 
				Tween.EASE_OUT_IN, 0.0)
		$Tween.interpolate_property(self, 
				"modulate", rand_color,
				Color(1.0, 1.0, 1.0), duration, Tween.TRANS_CUBIC, 
				Tween.EASE_IN_OUT, duration)
		$Tween.start()
