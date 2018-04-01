#!/bin/bash
./asm $1
./link $(echo $1 | sed "s/\..*\$//g").obj
./td $(echo $1 | sed "s/\..*\$//g").exe
