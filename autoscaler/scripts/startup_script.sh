#!/bin/bash
# Install stress and s-tui to stress the server and trigger the alarm.
sudo apt update && sudo apt upgrade -y
sudo apt install stress s-tui apache2 -y