import numpy, noise
from PIL import Image

# debug flags
CULLING = True
QUICK_RENDER = False
SHADING = True
MIRRORS = True
TRANSPARENCY = True
SHADOWS = True

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
trans = 0.1
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

def octave(magnitude, frequency, input, mod_func = lambda x : (x+1.0)/2.0):
	return {'magnitude': float(magnitude), 'frequency': float(frequency), 
			'input': input, 'mod_func': mod_func}

def simplex(base, noise_func, octaves):
	output = base

	output += sum([ 
			octave['magnitude'] * 
				octave['mod_func'](
					noise_func(
						*tuple(octave['input'] * octave['frequency'])
					)
				)
		for octave in octaves])

	return output


print "Generating", image_width, "x", image_height, "render"
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
		# r = 16.0
		# r += 16.0 * (noise.snoise3(*tuple(ray*18))+1.0)/2.0
		# r += 32.0 * (noise.snoise3(*tuple(ray*8))+1.0)/2.0
		# r += 64.0 * (noise.snoise3(*tuple(ray*4))+1.0)/2.0
		# r += 128.0 * (noise.snoise3(*tuple(ray*2))+0.5)/2.0
		# sky
		g = r = simplex(16, noise.snoise3, [octave(16, 16, ray), octave(32,8,ray), octave(64,4,ray), octave(128,2,ray,lambda x : (x+0.5)/2.0)])
		colour = vec(r, g, 256)

		# wood
		# r2d = numpy.array([ray[0], ray[1]])
		# r = simplex(0, noise.snoise2, [
		# 	octave(0.5, 200, r2d),
		# 	octave(0.7, 1, r2d * numpy.array([50.0, 1.0]))
		# 	])
		# r = (r+1.0)/2.0
		# colour = vec(180*r, 130*r, 80*r)

		numpy.clip(colour, 0, 256)
		raw[i,j] = tuple(colour.astype(int))

image.save("simplex/sky.png")