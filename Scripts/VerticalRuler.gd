extends Panel

const RULER_WIDTH := 16

var font := preload("res://Assets/Fonts/Roboto-Small.tres")
var major_subdivision := 2
var minor_subdivision := 5

var first : Vector2
var last : Vector2

# warning-ignore:unused_argument
func _process(delta) -> void:
	update()

func _draw() -> void:
	var transform := Transform2D()
	var ruler_transform := Transform2D()
	var major_subdivide := Transform2D()
	var minor_subdivide := Transform2D()
	var zoom := 1 / Global.camera.zoom.x
	transform.y = Vector2(zoom, zoom)

	transform.origin = Global.main_viewport.rect_size / 2 + (Global.camera.offset) * -zoom

	var basic_rule := 100.0
	var i := 0
	while(basic_rule * zoom > 100):
		basic_rule /= 5.0 if i % 2 else 2.0
		i += 1
	i = 0
	while(basic_rule * zoom < 100):
		basic_rule *= 2.0 if i % 2 else 5.0
		i += 1

	ruler_transform = ruler_transform.scaled(Vector2(basic_rule, basic_rule))

	major_subdivide = major_subdivide.scaled(Vector2(1.0 / major_subdivision, 1.0 / major_subdivision))
	minor_subdivide = minor_subdivide.scaled(Vector2(1.0 / minor_subdivision, 1.0 / minor_subdivision))

	first = (transform * ruler_transform * major_subdivide * minor_subdivide).affine_inverse().xform(Vector2.ZERO);
	last = (transform * ruler_transform * major_subdivide * minor_subdivide).affine_inverse().xform(Global.main_viewport.rect_size);

	for i in range(ceil(first.y), last.y):
		var position : Vector2 = (transform * ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(0, i))
		if i % (major_subdivision * minor_subdivision) == 0:
			draw_line(Vector2(0, position.y), Vector2(RULER_WIDTH, position.y), Color.white)
			var val = (ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(i, 0)).x
			draw_string(font, Vector2(0, position.y), str(int(val)))
		else:
			if i % minor_subdivision == 0:
				draw_line(Vector2(RULER_WIDTH * 0.33, position.y), Vector2(RULER_WIDTH, position.y), Color.white)
			else:
				draw_line(Vector2(RULER_WIDTH * 0.66, position.y), Vector2(RULER_WIDTH, position.y), Color.white)