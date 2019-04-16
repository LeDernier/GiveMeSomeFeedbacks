extends Node2D

export(Color) var color = Color(1.0, 1.0, 1.0)
const MIN_R = 5.0
const MAX_R = 20.0
const MAX_RANGE = 50.0

func _draw():
	for i in range(randi()%10):
		draw_circle(Vector2(rand_range(0.0, MAX_RANGE), 0.0).rotated(rand_range(0.0, 2*PI)), rand_range(MIN_R, MAX_R), color)
