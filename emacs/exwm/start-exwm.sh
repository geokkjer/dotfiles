#!/bin/sh  

# start EXWM --mm maximize emacs --debug-init drop into debugger

exec dbus-launch --exit-with-session emacs -mm --debug-init
