extends Resource
class_name ParabolicCurve

## X intercept. (a,0)
@export var a:float = 0.0

## X intercept. (b,0)
@export var b:float = 1.0

@export var m:float = 1.0

func sample(x:float) -> float:
	return m * (x - a) * (x - b)

func get_slope(x:float) -> float:
	# m * (x - a) * (x - b)
	# m * (x^2 - bx - ax + ab)
	# mx^2 - mbx - max + mab
	# mx^2 - mx(a + b) + mab
	
	return (2 * m * x) - (m * (a + b))
