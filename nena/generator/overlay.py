from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw 
import os
import sys

img = Image.open("satellite.jp2")
draw = ImageDraw.Draw(img)
# font = ImageFont.truetype(<font-file>, <font-size>)
font = ImageFont.truetype("Roboto-Light.ttf", 16)
# draw.text((x, y),"Sample Text",(r,g,b))
seed = int(os.getenv("SEED", "0"))
flag = os.getenv("FLAG", "FLAG{Placeholder}")
draw.text((0, 0), flag,(255,255,255),font=font)
img.save('flag.jp2')
