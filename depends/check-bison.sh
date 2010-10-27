#!/bin/sh
# check-bison.sh by Anisse Astier (????@???.???)

if ! which yacc >/dev/null 2>&1
then
  command=bison
else
  command=yacc
fi

$command -V 1> /dev/null || { echo "ERROR: Install bison before continuing."; exit 1; }
