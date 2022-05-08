#!/bin/bash

echo -e "Hostname:\n$(hostname -f)"
echo -e "env:\n$(env | sort)"

/app/entry eval Homework.Release.migrate
/app/entry start