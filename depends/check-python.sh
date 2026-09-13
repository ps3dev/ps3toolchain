#!/bin/sh
# check-python.sh by Naomi Peori (naomi@peori.ca)

## Prefer python3 (pyenv, Debian) over the unversioned python name.
python_bin=""
for c in python3 python; do
  command -v "$c" >/dev/null 2>&1 || continue
  python_bin="$c"
  break
done
[ -n "$python_bin" ] || { echo "ERROR: Install python before continuing."; exit 1; }

## python-config is often not on PATH; pyenv ships python3-config next to the interpreter.
pyconfig=""
for c in python3-config python-config; do
  command -v "$c" >/dev/null 2>&1 || continue
  pyconfig="$c"
  break
done
if [ -z "$pyconfig" ]; then
  pyhome=$("$python_bin" -c "import sys; print(sys.base_prefix)")
  for c in "$pyhome"/bin/python3-config "$pyhome"/bin/python*-config; do
    [ -x "$c" ] || continue
    pyconfig="$c"
    break
  done
fi
[ -n "$pyconfig" ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }

pyprefix=$("$pyconfig" --prefix) || { echo "ERROR: Install python-dev before continuing."; exit 1; }

python_h=""
for h in \
  "$pyprefix"/include/python*/Python.h \
  ${PYENV_ROOT:+$PYENV_ROOT/versions/*/include/python*/Python.h} \
  /opt/local/include/python*/Python.h \
  ${PYINSTALLDIR:+$PYINSTALLDIR/include/Python.h}
do
  [ -f "$h" ] || continue
  python_h="$h"
  break
done
[ -n "$python_h" ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }
