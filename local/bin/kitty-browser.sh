#!/bin/bash
# Open URLs in a terminal browser (w3m) inside kitty
exec kitty --title "browser" w3m "$@"
