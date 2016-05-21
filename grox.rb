#!/usr/bin/ruby

# ./grox.rb <dir>
#   +left, +right, flip: relative movement
#   left, right, normal, inverted: absolute movement

# devices to manipulate
$screen = 'eDP1'
$touchscreen = 'Atmel Atmel maXTouch Digitizer'
$touchpad = 'ETPS/2 Elantech Touchpad'
$keyboard = 'AT Translated Set 2 keyboard'

# disable keypad and touchpad on all but normal orientation
$controlKeys = false

# runs cmd and greps output to find orientation
$orientationCmd = 'xrandr'
$orientationRE = /\s*#{$screen}\s+\w+\s+[x+\d]+\s+(|left|right|inverted)\s*\(/

# default direction
$defaultDirection = 'right'


# CODE

def main()
    direction = $defaultDirection

    if ARGV.length > 0
        direction = ARGV[0]
    end

    doOrientate(getNewOrientation(direction))
end


def orientateCmd(orientation, transform)
    rotateScreen = "xrandr --output #{$screen}" +
                         " --rotate #{orientation}";
    rotateTouchscreen = "xinput --set-prop '#{$touchscreen}'" +
                              " --type=float" +
                              " 'Coordinate Transformation Matrix'" +
                              " #{transform}"
    controlKeys = ""
    if $controlKeys
        setCmd = orientation == 'normal' ? 'xinput --enable ' 
                                         : 'xinput --disable '
        controlKeys = "#{setCmd} '#{$touchpad}'; #{setCmd} '#{$keyboard}';"
    end

    return controlKeys +
           rotateScreen + ';' +
           rotateTouchscreen + ';'
end


def doOrientate(orientation)
    case orientation
    when 'normal'
        `#{orientateCmd('normal', '1 0 0 0 1 0 0 0 1')}`
    when 'left'
        `#{orientateCmd('left', '0 -1 1 1 0 0 0 0 1')}`
    when 'right'
        `#{orientateCmd('right', '0 1 0 -1 0 1 0 0 1')}`
    when 'inverted'
        `#{orientateCmd('inverted', '-1 0 1 0 -1 1 0 0 1')}`
    else
        raise "Don't know how to orientate to #{orientation}"
    end
end


# returns direction of $screen: left, right, normal or invert
def getOrientation()
    if `#{$orientationCmd}` =~ $orientationRE
        return $1 == '' ? 'normal' : $1
    else
        raise "Could not determine orientation of #{$screen} from #{$orientationCmd}"
    end
end


# direction should be +left, +right, flip, left, right, normal, or inverted
def getNewOrientation(direction)
    clockwise = ['normal', 'right', 'inverted', 'left']

    if clockwise.include?(direction)
        return direction
    else
        curdir = clockwise.find_index(getOrientation())

        shift = case direction
                when '+left' then -1
                when '+right' then 1
                when 'flip' then 2
                else
                    raise "Unrecognised rotate direction #{direction}"
                end
       
        newdir = (curdir + shift) % 4

        return clockwise[newdir]
    end
end


# DO
main()


