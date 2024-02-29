#!/bin/bash
xrandr --newmode "2560x1440_40.00"  201.00  2560 2720 2984 3408  1440 1443 1448 1476 +hsync +vsync
xrandr --addmode Virtual-1 2560x1440_40.00
xrandr --output Virtual-1 --mode 2560x1440_40.00 --verbose
