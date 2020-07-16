#!/usr/bin/python
from __future__ import absolute_import, division, print_function, unicode_literals

""" The basic ForestWalk but with shadows cast onto the ElevationMap using
the ShadowCaster class.
Also demonstrates passing an array of objects to the MergeShape.merge()
method which is much faster for adding large numbers of objects
"""

import math, random, sys

#import demo
import pi3d
from sun import findSun

L_MIND = 40.
L_MAXD = 75.
L_MINA = 25.
L_MAXA = 90.-L_MINA

C_MIND = 90 - 8.
C_MAXD = 90 - 15.
C_MINA = 10.
C_MAXA = 90.-C_MINA
CALT=100.

camera_seed = int(sys.argv[1])
shadow_seed = int(sys.argv[2])
print(camera_seed, shadow_seed)
random.seed(shadow_seed)
lat = random.random() * (65. - 20.) + 20.
lon = random.random() * 360. - 180.

while True:
    minute = 0
    if camera_seed != 1:
        minute = random.randint(0,3) * 15
    hour = random.randint(1,24)
    month = random.randint(1,12)
    year = 2019
    day = random.randint(1,28)
    light_az,light_ev = findSun(lat,lon,hour, tmin=minute, td=day, tm=month, ty=year)
    if abs(light_az) > 85 and abs(light_az) < 95:
        continue
    if abs(light_az) > 175 and abs(light_az) < 185:
        continue
    if abs(light_az) > 265 and abs(light_az) < 275:
        continue
    if abs(light_az) > 355 and abs(light_az) < 5:
        continue
    if light_ev >= L_MIND and light_ev <= L_MAXD:
        break

random.seed(camera_seed)

camera_ev = random.random() * (C_MAXD-C_MIND) + C_MIND
camera_az = random.random() * (C_MAXA-C_MINA) + C_MINA + 90. * random.randint(0,3)

# Setup display and initialise pi3d
DISPLAY = pi3d.Display.create(frames_per_second=30,w=2048,h=2048)
DISPLAY.set_background(0.4,0.8,0.8,1)      # r,g,b,alpha
# yellowish directional light blueish ambient light
#TODO doesn't cope with z direction properly
LA = math.radians(light_az)
LE = -math.radians(light_ev)
LC = 1
LZ = LC*math.cos(LA)*math.cos(LE)
LX = LC*math.sin(LA)*math.cos(LE)
LY = LC*math.sin(LE)
mylight = pi3d.Light(lightpos=(LX,LY,LZ), lightcol=(1.0, 1.0, 1.0), lightamb=(0.40, 0.35, 0.35))

CA = math.radians(camera_az)
CE = -math.radians(camera_ev)
CC = CALT
CZ = CC*math.cos(CA)*math.cos(CE)
CX = CC*math.sin(CA)*math.cos(CE)
CY = CC*math.sin(CE)
CAMERA = pi3d.Camera.instance()

if light_az > 180.:
    light_az -= 360.
elif light_az < -180.:
    light_az += 360
if camera_az > 180.:
    camera_az -= 360.
elif camera_az < -180.:
    camera_az += 360
    
print("Time (mm, h,d,m,y)", minute, hour, day, month, year)
print("Light Az/Ev", light_az, light_ev)
print("Camera Az/Ev", -camera_az, camera_ev)
print("Lat/Lon", lat, lon)

#========================================
# load shader
shader = pi3d.Shader("shadow_uv_bump")
flatsh = pi3d.Shader("uv_flat")
lightsh = pi3d.Shader("uv_light")

bumpimg = pi3d.Texture("textures/grasstile_n.jpg")
#black = pi3d.Texture("textures/black.jpg")
#bumpimg = pi3d.Texture("textures/black.jpg")
checkerboard = pi3d.Texture("textures/glassbuilding.jpg")


w = 5.0
h = 10.0
d = 5.0
x = -10.0
z = -10.0
lh = 35
lw = 3
ld = 3
ow = 3
oh = 25
od = 3
cubes = []
cubes.append(pi3d.Cuboid(x=0,y=lh/2,z=-20, w=ow, h=lh, d=od))
for x,z in [
        [  0,  0], 
        [-20,  0], 
        [ 20,  0], 
        [  0,  20], 
        ]:
    cubes.append(pi3d.Cuboid(
        x=x,# + random.random() * 5,
        y=h/2,
        z=z,# + random.random() * 5,
        w=ow,# + random.randint(0,3) * 2,
        h=oh,# + random.randint(0,4) * 10,
        d=od# + random.randint(0,3) * 2
        ))

cube2 = pi3d.Cuboid(x=50,y=h/2,z=50,  w=w,h=h,d=d)
cube2.set_draw_details(lightsh, [checkerboard])

#myecube = pi3d.EnvironmentCube(900.0,"HALFCROSS")
ectex=pi3d.loadECfiles("textures/ecubes","sbox")
myecube = pi3d.EnvironmentCube(size=900.0, maptype="FACES", name="cube")
myecube.set_draw_details(flatsh, ectex)

# Create elevation map
mapwidth = 700.0
mapdepth = 700.0
mapheight = 0.0001 # can't cope with much elevation
mountimg1 = pi3d.Texture("textures/grass.jpg",m_repeat=True)
mymap = pi3d.ElevationMap("textures/black.jpg", name="map",
                     width=mapwidth, depth=mapdepth, height=mapheight,
                     divx=32, divy=32) #testislands.jpg
mymap.set_draw_details(shader, [mountimg1, bumpimg, bumpimg], 128.0, 0.0)

#screenshot number
scshots = 1

#avatar camera
xm = CX
zm = CZ
ym = -CY

myshadows = pi3d.ShadowCaster(position=[LX, LY, LZ], scale=10, light=mylight)

# Fetch key presses
mykeys = pi3d.Keyboard()

# main loop
while DISPLAY.loop_running():
    CAMERA.reset()
    #CAMERA.rotate(tilt, rot, 0)
    CAMERA.position((xm, ym, zm))
    CAMERA.point_at([0,0,0])

    # put the shadows onto the shadowcaster texture
    myshadows.start_cast([LX,LY,LZ])#[xm, ym, zm])
    for cube in cubes:
        myshadows.cast_shadow(cube)
    myshadows.end_cast()

    mymap.draw(shader, [mountimg1, bumpimg, myshadows], 128.0, 0.0, light_camera=myshadows.LIGHT_CAM)
    for cube in cubes:
        cube.draw(lightsh, [checkerboard])#, light_camera=myshadows.LIGHT_CAM)

    k = mykeys.read()
    if k == 112:
        pi3d.screenshot("capture"+str(camera_seed)+"_"+str(shadow_seed)+".jpg")
        with open("receipt" + str(camera_seed) + "_" + str(shadow_seed) + ".txt", 'w') as f:
            f.write("Time:%02d-%02d-%02d-%02d-%04d\n" % (minute, hour, day, month, year))
            f.write("Pos:%0.4f,%0.4f\n" % (lat, lon))
            f.write("Camera:%0.4f,%0.4f\n" % (-camera_az, camera_ev))
            f.write("Light:%0.4f,%0.4f\n" % (light_az, light_ev))
        break
    elif k == 27:  #Escape key
        break
        
    CAMERA.was_moved = False
mykeys.close()
DISPLAY.stop()
quit()
