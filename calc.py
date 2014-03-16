from collections import Counter, defaultdict
from decimal import Decimal, getcontext
import itertools
import math
from math import cos, e, factorial, pi, sin, sqrt
from math import log as ln
from math import log10 as log
import operator
import random
from unicodedata import name as unicode_name

from kalgynirae.random.maths import factors, primes, prime_factors

D = Decimal

speed_of_light = 3.00e8
G = 6.67e-11

def kelvin(celcius):
    return 273.15 + celcius
k = kelvin

def celcius(kelvin):
    return kelvin - 273.15
c = celcius

def fahrenheit(celcius):
    return celcius * 9 / 5 + 32
f = fahrenheit

def avg(iterable):
    sum = 0
    for n, x in enumerate(iterable):
        sum += x
    return sum / (n + 1)

def std(iterable):
    l = list(iterable)
    a = avg(l)
    squared_differences = ((x - a) ** 2 for x in l)
    return sqrt(avg(squared_differences))
