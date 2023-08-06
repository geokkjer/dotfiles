#!/bin/env bash
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "/home/geir/dotfiles/systems/servers/server1.org")'
