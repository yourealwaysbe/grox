
GROX
----

A simplish script for rotating touchscreens.  Takes care of rotating the
touchscreen co-ordinates also, and optionally disables the keyboard and touchpad
for all rotations except the normal orientation (useful for laptops with flip
screens).


DEPENDS
-------

xrandr


SETUP
-----

Set the variables at the top of the file with your screen, touchscreen, keyboard
and touchpad names (from xinput --list).

Set $controlKeys to false if you don't want the script to turn your keyboard and
touchpad on for normal orientation, and off for all others.


RUN
---

    $ grox.sh <dir>

Where <dir> is one of:

    normal, left, right, invert: 
        absolute orientations
    +left, +right, flip: 
        relative rotations
