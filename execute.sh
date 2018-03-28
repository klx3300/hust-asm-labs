#!/bin/bash
echo "@echo off" > auto.bat
echo "$@ > output.txt" >> auto.bat
echo "exit" >> auto.bat
dosbox -conf dosbox.template
cat OUTPUT.TXT
