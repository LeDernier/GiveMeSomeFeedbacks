extends "res://game/ParamManager.gd"

export(float) var CAM_SHAKE = 0.0
var cam_speed = Vector2(0, 0)

export(bool) var SCORE = false
export(bool) var SCORE_COLORS = false
var score_pts= 0.0
export(bool) var BLUR_EFFECT = false
export(bool) var BLOOD = false
var init_pos = {}
export(bool) var SOUNDS = false

func _ready():
	add_param($Camera2D/Stars, "visible", "background")
	add_param($Player/Trail, "visible", "player trail")
	add_param($Mob/Trail2, "visible", "mob trail")
	add_param($Mob2/Trail3, "visible", "mob2 trail")
	add_param($Player, "CONTACT_FEEDBACK", "player contact")
	add_param($Mob, "CONTACT_FEEDBACK", "mob contact")
	add_param($Mob2, "CONTACT_FEEDBACK", "mob2 contact")
	add_param(self, "CAM_SHAKE", "camera shake")
	add_param($Player, "EYE", "eye")
	add_param(self, "BLUR_EFFECT", "blur on hit")
	add_param(self, "SCORE", "score")
	add_param(self, "SCORE_COLORS", "score colors")
	add_param(self, "BLOOD", "blood")
	add_param(self, "SOUNDS", "sounds")
	# Dealing save
	var new_label = Label.new()
	new_label.text = "play replay"
	$Params/VBoxContainer/Grid.add_child(new_label)
	var new_button = Button.new()
	new_button.connect("pressed", self, "_replay_request")
	$Params/VBoxContainer/Grid.add_child(new_button)
	# Saving position
	for c in get_children():
		if c is Node2D:
			init_pos[c] = c.position
	
func _process(delta):
	cam_speed += (-200.0 * ($Camera2D.position - Vector2(512, 300)) - 5.0 * cam_speed) * delta
	$Camera2D.position += cam_speed * delta

func _on_Collision(velocity):
	cam_speed -= velocity * CAM_SHAKE

func _on_Player_hurt(velocity, pos):
	if BLUR_EFFECT:
		if $Tween.get_runtime() == 0.0:
			$Tween.interpolate_property($Shader, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Tween.interpolate_property($Shader, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.1)
			$Tween.start()
	if SCORE:
		var diff = score_pts
		score_pts = max(score_pts - 0.3 * velocity, 0)
		diff = diff - score_pts
		$Score/ColorRect.rect_min_size.x = score_pts
		$Score/ColorRect.color = Color(1-score_pts/500, score_pts/250 + 0.5, 0.3)
		if SCORE_COLORS:
			$Score/Tween.stop_all()
			$Score/ColorRect2.color = Color(0.7, 0.0, 0.3)
			$Score/Tween.interpolate_property($Score/ColorRect2, "rect_min_size", Vector2(diff, 20), Vector2(0, 20), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Score/Tween.start()
	if BLOOD:
		var new_blood = load("res://game/Blood.tscn").instance()
		new_blood.color = Color(rand_range(0.3, 0.6), rand_range(0.0, 0.1), rand_range(0.0, 0.2))
		add_child(new_blood)
		new_blood.global_position = pos
	if SOUNDS:
		#print(-1 + 0.001 * velocity)
		$ProceduralAudioTest.volume_db = -20 + 0.03 * velocity
		$ProceduralAudioTest.play_rand(0.03, 0.04, 0.1)

func _on_Mob_hurt(velocity, pos):
	if SCORE:
		var old_score = score_pts
		score_pts = min(score_pts + 0.1 * velocity, 500)
		$Score/ColorRect.rect_min_size.x = score_pts
		$Score/ColorRect.color = Color(1-score_pts/500, score_pts/250 + 0.5, 0.3)
		if SCORE_COLORS:
			$Score/Tween.stop_all()
			$Score/Tween.interpolate_property($Score/ColorRect, "rect_min_size", Vector2(old_score, 20), Vector2(score_pts, 20), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Score/ColorRect2.color = Color(0.0, 0.7, 0.3)
			$Score/Tween.interpolate_property($Score/ColorRect2, "rect_min_size", Vector2(score_pts - old_score, 20), Vector2(0, 20), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$Score/Tween.start()
	if BLOOD:
		var new_blood = load("res://game/Blood.tscn").instance()
		new_blood.color = Color(rand_range(0.0, 0.1), rand_range(0.3, 0.6), rand_range(0.0, 0.2))
		add_child(new_blood)
		new_blood.global_position = pos
	if SOUNDS:
		$ProceduralAudioTest2.volume_db = -10 + 0.015 * velocity
		$ProceduralAudioTest2.play_rand(0.005, 0.0052, 0.2)
	
func _replay_request():
	# Reset position and physics
	for c in get_children():
		if c is Node2D:
			if c in init_pos:
				c.position = init_pos[c]
				if c is RigidBody:
					c.linear_velocity = 0.0
					c.angular_velocity = 0.0
			else:
				c.queue_free()
	# Play saved events
	$InputSaver.play_saved()