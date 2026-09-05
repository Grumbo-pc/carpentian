#!/bin/bash
# Carpentian panel layout - runs on every login
dconf write /org/cinnamon/panels-enabled "['1:0:bottom']"
dconf write /org/cinnamon/panels-height "['1:40']"
dconf write /org/cinnamon/next-applet-id 12
dconf write /org/cinnamon/enabled-applets "['panel1:left:0:app-drawer@mostlynick3:1', 'panel1:center:0:grouped-window-list@cinnamon.org:2', 'panel1:right:7:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:5:notifications@cinnamon.org:5', 'panel1:right:4:network@cinnamon.org:6', 'panel1:right:3:sound@cinnamon.org:7', 'panel1:right:2:user@cinnamon.org:11', 'panel1:right:1:power@cinnamon.org:8', 'panel1:right:0:calendar@cinnamon.org:9']"
