import math

def is_in_triangle(p, p0, p1, p2):
  ''' is p inside the triangle formed by p0, p1, p2 '''
  p1 = [p1[0] - p0[0], p1[1] - p0[1]]
  p2 = [p2[0] - p0[0], p2[1] - p0[1]]
  den = p1[0] * p2[1] - p1[1] * p2[0]
  #print(p1, p2, den)
  a = (p[0] * p2[1] - p[1] * p2[0] - p0[0] * p2[1] + p0[1] * p2[0]) / den
  #print(a)
  if a <= 0:
    return False
  b = -(p[0] * p1[1] - p[1] * p1[0] - p0[0] * p1[1] + p0[1] * p1[0]) / den
  #print(b)
  if b <= 0 or (a + b) >= 1:
    return False
  return True


def is_convex(p, prior, post, return_angle=False):
  p0 = [p[0] - prior[0], p[1] - prior[1]]
  p1 = [post[0] - p[0], post[1] - p[1]]
  crossp = p0[0] * p1[1] - p0[1] * p1[0]
  convex = 1
  if crossp < 0:
    convex = -1
  if return_angle:
    dot = p0[0] * p1[0] + p0[1] * p1[1]
    angle = math.atan2(crossp, dot)
    return convex, angle
  return convex, None

#verts = [(0,0),(0.5,1),(-0.5,1),(-0,2),(3,2),(2.5,1),(1.5,1),(1,0)]
verts = [(0,0),(1,2),(0,3),(2,3),(2,2),(3,3),(3,2),(2,0),(1,1)]
#verts = [(0,0),(2,-2),(4,0),(2,2)]
n = len(verts)
cumangle = 0.0
clockwise = 1
for i in range(n):
  conv, angle = is_convex(verts[i], verts[i-1], verts[(i+1)%n], True)
  cumangle += angle
if cumangle > 0:
  clockwise = -1

triangles = []
vlist = list(range(n))
i = 0
while n > 3:
  conv, _ = is_convex(verts[i], verts[i-1], verts[(i+1)%n])
  conv *= clockwise
  if conv < 0: # this is an ear so test if it includes another point
    abort = False
    for ix in range(n - 3):
      ixwrap = (i + 2 + ix) % n
      print(ixwrap)
      if is_in_triangle(verts[ixwrap], verts[i], verts[i-1], verts[(i+1)%n]):
        abort = True
        break
    if not abort:
      triangles.append((vlist[i], vlist[(i+1)%n], vlist[(i-1)%n]))
      verts.pop(i)
      vlist.pop(i)
      n -= 1
  i = 0 if i >= (n - 1) else i + 1

triangles.append((vlist[0], vlist[1], vlist[2]))
print(triangles)

