#!/bin/bash
# Wait for 1 second to allow the lock screen to appear
# This is necessary to prevent the monitors from powering off before the lock screen is displayed
sleep 1
niri msg action power-off-monitors
