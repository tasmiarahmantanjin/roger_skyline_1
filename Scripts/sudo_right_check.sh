#!/bin/sh

if groups | grep "\<sudo\>" &> /dev/null; then
	echo yes
else
	echo no
fi
