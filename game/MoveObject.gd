extends RigidBody2D

# Sets the velocity of the player
export(float) var AIM_SPEED = 400
# Sets the friction multiplier
export(float) var COEF_FRICT = 10
# Sets the acceleration multiplier
export(float) var COEF_ACC = 50

# Input variables
var input_dir = Vector2(0, 0)

# The movement force represents the force that makes your character move is the direction the player want.
# The friction force represents
func _physics_process(delta):
	var move_force = Vector2(0, 0)
	var frict_force = Vector2(0, 0)
	
	# Compute forces
	if(input_dir.length() > 0):
		var n = input_dir.normalized()
		# Speed projection on the direction the player wants to go
		var s = linear_velocity.dot(n)
		# Speed projection on the direction the player wants to be stoped
		var t = linear_velocity - s * n
		if(s < AIM_SPEED):
			# Dealing with the MOVE_FORCE just here
			move_force +=  n * COEF_ACC * (AIM_SPEED - s)
			if s <= 0:
				# If you want to turn round, friction should help.
				frict_force += -COEF_FRICT * linear_velocity
			else:
				# If not, friction should only decrease movement where the player doesn't want to go.
				frict_force += -COEF_FRICT * t
		else:
			frict_force += -COEF_FRICT * linear_velocity
	else:
		frict_force += -COEF_FRICT * linear_velocity
	
	# Apply forces
	apply_central_impulse(move_force * delta)
	apply_central_impulse(frict_force * delta)
