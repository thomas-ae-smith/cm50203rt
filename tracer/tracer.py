import numpy
from PIL import Image

# debug flags
CULLING = True
QUICK_RENDER = False
SHADING = True
MIRRORS = True
TRANSPARENCY = True

# shorthand
def vec(a, b, c):
	return numpy.array([a, b, c])

# use numpy to normalise a vector
def normalise(v):
	v /= numpy.linalg.norm(v)
	return v

# Calculate half-vector
def H(camera, light):
	# print camera, light
	return normalise(normalise(camera) + normalise(light))

# load an .obj file vertices and apply uniform colour
def readobj(filename, name, colour):
	obj = {}
	points = []
	norms = []
	tris = []

	for line in open(filename, 'r'):
		line = line.split()
		if line[0] == "v":
			points += [vec(float(line[1]), float(line[2]), float(line[3]))]
		if line[0] == "vn":
			norms += [vec(float(line[1]), float(line[2]), float(line[3]))]
		if line[0] == "f":
			tri = []
			for f in line[1:]:
				f = f.split("/")
				tri += [points[int(f[0])-1]]
			tris += [tri]
	obj['tri'] = tris
	obj['colour'] = colour
	obj['name'] = name
	obj['centre'] = vec(numpy.mean([x[0] for x in points]), numpy.mean([x[1] for x in points]), numpy.mean([x[2] for x in points]))
	obj['radius'] = max(map(numpy.linalg.norm, [x - obj['centre'] for x in points]))
	return obj



# cylinder = 'Trns_xrot(  1.5708 )*Trns_shift( [-1 1 -1] )';
# cube = 'Trns_shift( [2 0.5 1] )';		*2?
# plane = 'Trns_xrot(  1.5708 )';		*15?
# window = [256 256 1 1]; % you can define the window differently if you like

objects = []
# objects[0] = {'name': "mirror", 'colour': vec(128, 0, 0), 'tri': [[vec(2, 2, 4), vec(-2, 0, 4), vec(-2, 2, 4)],[vec(2, 2, 4), vec(2, 0, 4), vec(-2, 0, 4)]], 'centre': vec(0, 1, 4,), 'radius': numpy.sqrt(4.0), 'mirror': True}
objects.append(readobj('mirror.obj', 'mirror', vec(0, 0, 128)))
objects.append({'name': "sphere", 'colour': vec(0, 128, 128), 'tri': [], 'centre': vec(-4, 4, 2), 'radius': 2.0})
objects.append(readobj('cube.obj', 'cube', vec(0, 0, 256)))
objects.append(readobj('cylinder.obj', 'cylinder', vec(0, 0, 256)))
objects.append(readobj('plane.obj', 'plane', vec(128, 128, 0)))
#  object.colour: Each row gives the colour of the corresponding triangle. First three columns are RGB values. Final two are a reflectance and refraction index for full ray-tracing.
#  object.n: The normal for each triangle.

# The resolution for this render
image_width = 360
image_height = 200
# The size of the image plane (in the 3D space)
window_width = (image_width*1.0)/image_height
window_height = 1
# The values to use for the ambient light, RGB.
ambientlight = vec(0.3, 0.3, 0.3)
Kd = 0.005
Ks = 0.4
p = 10
trans = 0.7
# Directional light locations
lights = [[vec(5, 5, -5), vec(256,256,256)], [vec(-10, 5, -5), vec(256, 32, 32)]]
# The focal point of the camera in 3D space.
cam_focus = vec(0, 3, -10)
# The distance between the focal point and the image plane.
cam_focallength = 1
# The orientation of the camera.
cam_up = vec(0, 1, 0)
cam_right = vec(1, 0, 0)
cam_normal = vec(0, 0, 1)
# The centre of the image plane, computed from the other values for easy reference.
cam_coi = cam_focus + cam_normal * cam_focallength
cam_tlp = cam_coi - cam_right * 0.5 * window_width + cam_up * 0.5 * window_height
# returns the world coordinates of a point on the image plane
# where x and y are planespace coordinates [0-r] and [0-1]
def getWindowPoint(x, y):
	return cam_tlp + x * cam_right - y * cam_up


def intersect(origin, ray, obj):
	# initialise a collision record
	c_rec = {'hit': False, 'colour': obj['colour']}
	# initialise t to maximum possible
	t = numpy.inf

	# check the culling sphere collision
	if (CULLING):
		sr = obj['centre'] - origin
		dsr = numpy.dot(sr, ray)

		d = dsr*dsr - numpy.dot(sr,sr) + obj['radius'] * obj['radius']
		if d < 0: return c_rec
		d = numpy.sqrt(d)
		
		t1 = dsr + d
		if t1 < 0: return c_rec
		
		t2 = dsr - d
		if t2 > t: return c_rec

		# if no faces defined (it's a sphere) or rendering only culling spheres
		if (obj['tri'] == [] or QUICK_RENDER):
			if t2 < 0:
				t = t1
			else:
				t = t2
			c_rec = {'hit': True, 't': t, 'colour': obj['colour'], 'norm': normalise((t*ray)-sr)}
			return c_rec

	# fast ray-triange, as in http://www.scratchapixel.com/lessons/3d-basic-lessons/lesson-9-ray-triangle-intersection/m-ller-trumbore-algorithm/
	for i, points in enumerate(obj['tri']):
		e1 = points[1] - points[0]
		e2 = points[2] - points[0]
		pvec = numpy.cross(ray, e2)
		det = numpy.dot(e1, pvec)

		# back-face culling
		# if (det < 1e-6):
		# 	continue

		invdet = 1/det
		tvec = origin - points[0]
		u = numpy.dot(tvec, pvec) * invdet
		if (u < 0 or u > 1):
			continue
		qvec = numpy.cross(tvec, e1)
		v = numpy.dot(ray, qvec) * invdet
		if (v < 0 or v > 1):
			continue
		if (u+v > 1):
			continue

		if (0 < numpy.dot(e2, qvec) * invdet < t):
			# we've found a collision, record the variables
			c_rec['hit'] = True
			c_rec['t'] = t = numpy.dot(e2, qvec) * invdet
			c_rec['tri_id'] = i
			c_rec['norm'] = normalise(-numpy.cross(e1, e2)) if (det < 1e-6) else normalise(numpy.cross(e1, e2))
			c_rec['u'] = u
			c_rec['v'] = v
			c_rec['colour'] = obj['colour']

	return c_rec


# trace a numpy vector
def trace(origin, ray):
	t = numpy.inf
	c_rec = {'hit': False}

	for i, obj in enumerate(objects):
		coll = intersect(origin, ray, obj)
		if coll['hit'] and coll['t'] < t:
				c_rec = coll
				t = c_rec['t']
				c_rec['obj_id'] = i

	# if we've failed to hit anything, return a background colour
	if c_rec['hit'] == False:
		return vec(0, 128, 0)

	colour = c_rec['colour']
	norm = c_rec['norm']
	obj = objects[c_rec['obj_id']]

	# reflected ray from http://paulbourke.net/geometry/reflected/
	if MIRRORS and obj['name'] == 'mirror':
		# print origin+t*ray, normalise(ray - 2.0 * norm * numpy.dot(ray, norm))
		colour = trace(origin+(t*ray*0.99), normalise(ray - 2.0 * norm * numpy.dot(ray, norm)))
	
	if TRANSPARENCY and obj['name'] == 'cylinder':
		# print origin+t*ray, normalise(ray - 2.0 * norm * numpy.dot(ray, norm))
		colour = trans*colour + (1-trans) * trace(origin+(t*ray*1.01), ray)

	if not SHADING:
		return colour

	La = Ld = Ls = vec(0,0,0)

	La = ambientlight * colour

	if not (MIRRORS and obj['name'] == 'mirror'):
		Ld = Kd * sum([(light[1] * max(0, numpy.dot(norm, light[0] - (origin + t * ray)))) for light in lights])

	Ls = Ks * sum([(light[1] * numpy.power(max(0, numpy.dot(norm, H(-ray, light[0] - (origin + t * ray)))), p)) for light in lights])

	# print (La + Ld + Ls)
	return numpy.clip(La + Ld + Ls, 0, 256)




image = Image.new("RGB", (image_width, image_height))
raw = image.load()

# subdivide the windowspace into image_width pixels (i is the #iteration)
for i, x in enumerate(numpy.linspace(0, window_width, image_width)):
	# print approximate progress every 10 iterations
	if i % 10 == 0:
		print (i * 100.0) / image_width, "%"
	# subdivide the windowspace into image_height pixels (i is the #iteration)
	for j, y in enumerate(numpy.linspace(0, window_height, image_height)):
		ray = getWindowPoint(x, y) - cam_focus
		ray = normalise(ray)
		colour = trace(cam_focus, ray)
		raw[i,j] = tuple(colour.astype(int))

image.save("imgs/scene.png")