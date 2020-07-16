#!/usr/bin/python

import cgi, os
import math

url = cgi.FieldStorage()
camera=url['CAMERA'].value
camera=camera.split(',')
camlooklng=float(camera[0])
camlooklat=float(camera[1])
camlookrng=float(camera[2])
camlooktlt=float(camera[3])
camlookhed=float(camera[4])

def isValid(f):
    return (not math.isnan(f)) and (not math.isinf(f))

valid = isValid(camlooklng) and isValid(camlooklat) and isValid(camlookrng) and isValid(camlooktlt) and isValid(camlookhed)
