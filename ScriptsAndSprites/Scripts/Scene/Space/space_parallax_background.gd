extends ParallaxBackground

var move_speed = 5000

func _process(delta):
	change_speed()
	scroll_base_offset -= Vector2(0.1, -move_speed) * delta
	pass

func change_speed():
	if move_speed >= 10:
		move_speed -= 10
		if move_speed <= 0:
			move_speed = 0.1
