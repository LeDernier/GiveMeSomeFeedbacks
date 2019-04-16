extends AudioStreamPlayer

var playback = get_stream_playback()

var INCR_MIN = 0.0
var INCR_MAX = 0.0
func play_rand(incr_min, incr_max, duration):
	INCR_MIN = incr_min
	INCR_MAX = incr_max
	$Timer.wait_time = duration
	$Timer.start()
	play()

func _process(delta):
	_fill_buffer()

var phase = 0.0
func _fill_buffer():
		var to_fill = playback.get_frames_available()
		while (to_fill > 0):
			playback.push_frame( Vector2(1.0,1.0) * sin(phase * (PI * 2.0))) 
			phase = fmod((phase + rand_range(INCR_MIN, INCR_MAX)), 1.0)
			to_fill-=1

func _on_Timer_timeout():
	stop()
