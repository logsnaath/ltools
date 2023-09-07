#!/usr/bin/python3
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

import numpy as np

w=0.15
v=500.0
br=float(0)
bh=float(0)

best=v
for r in np.arange(2.0, 8.0, 0.01):
    a = 3.14*(r**2)
    h = v/a
    mvol = 3.14*((r+w)**2)*(h+w)-(r**2)*h
    print ("r =", r, "h =", h, end=" ====>  ")
    print ( "mvol =", mvol)
    
    if ( best > mvol ):
        best=mvol
        br=r
        bh=h

print( "=================\n", br, bh, best)


