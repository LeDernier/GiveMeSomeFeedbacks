extends "MoveObject.gd"

signal collision(velocity)
signal hurt(velocity, pos)

export(bool) var CONTACT_FEEDBACK = false 

export(NodePath) var AIM_PATH
var AIM_NODE : Node2D = null

func _ready():
	AIM_NODE = get_node(AIM_PATH)

func _process(delta):
	input_dir = AIM_NODE.global_position - global_position

# Draw
func _draw():
	draw_circle(Vector2(0.0, 0.0), $CollisionShape2D.shape.radius, Color(1.0, 0.5, 0.0))
	
func _on_Mob_body_entered(body):
	# Managing signals
	emit_signal("collision", linear_velocity)
	if !body.is_in_group("player"):
		emit_signal("hurt", linear_velocity.length(), global_position)
	# Managing contact feedback
	if(CONTACT_FEEDBACK):
		var rand_color = Color()
		if body.is_in_group("player"):
			rand_color = Color(rand_range(0.8, 1.0), rand_range(0.8, 1.0), rand_range(0.0, 0.2))
		else:
			rand_color = Color(rand_range(0.0, 0.1), rand_range(0.0, 0.1), rand_range(0.0, 0.1))
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
