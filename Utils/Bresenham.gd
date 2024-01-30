static func plot_line(point0: Vector2, point1: Vector2) -> Array:
	var x0 = point0.x
	var y0 = point0.y
	var x1 = point1.x
	var y1 = point1.y
	if abs(y1 - y0) < abs(x1 - x0):
		if x0 > x1:
			return _plot_line_low(point1, point0)
		else:
			return _plot_line_low(point0, point1)
	else:
		if y0 > y1:
			return _plot_line_high(point1, point0)
		else:
			return _plot_line_high(point0, point1)

static func _plot_line_low(point0: Vector2, point1: Vector2) -> Array:
	var points = []
	var x0 = point0.x
	var y0 = point0.y
	var x1 = point1.x
	var y1 = point1.y
	var dx = x1 - x0
	var dy = y1 - y0
	var yi = 1
	if dy < 0:
		yi = -1
		dy = -dy
	var D = (2 * dy) - dx
	var y = y0
	if x1 == x0:
		return points
	for x in range (x0, x1, (x1 - x0) / abs(x1 - x0)):
		points.push_back(Vector2(x, y))
		if D > 0:
			y = y + yi
			D = D + (2 * (dy - dx))
		else:
			D = D + 2*dy
	return points

static func _plot_line_high(point0: Vector2, point1: Vector2) -> Array:
	var points = []
	var x0 = point0.x
	var y0 = point0.y
	var x1 = point1.x
	var y1 = point1.y
	var dx = x1 - x0
	var dy = y1 - y0
	var xi = 1
	if dx < 0:
		xi = -1
		dx = -dx
	var D = (2 * dx) - dy
	var x = x0
	if y1 == y0:
		return points
	for y in range(y0, y1, (y1 - y0) / abs(y1 - y0)):
		points.push_back(Vector2(x, y))
		if D > 0:
			x = x + xi
			D = D + (2 * (dx - dy))
		else:
			D = D + 2*dx
	return points
