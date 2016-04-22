#!/bin/sh

set -eux
set -o pipefail

swiftgen="$PODS_ROOT/SwiftGen/bin/swiftgen"

compile() {
    local clrfile="$1"
    local libfile="$HOME/Library/Colors/$clrfile"
    local catfile="UIColor+${1/.clr/.swift}"
    local buildroot
    buildroot=$(cd "$CONFIGURATION_TEMP_DIR/../.."; pwd)
    local builddir="$buildroot/colors"
    local buildfile="$builddir/$catfile"

    if [ ! -e "$libfile" -o "$clrfile" -nt "$libfile" ]
    then
        cp "$clrfile" "$libfile"
        touch -r "$clrfile" "$libfile"
    elif [ "$libfile" -nt "$clrfile" ]
    then
        cp "$libfile" "$clrfile"
        touch -r "$libfile" "$clrfile"
    fi

    if [ ! -f "$buildfile" -o "$clrfile" -nt "$buildfile" ]
    then
      mkdir -p "$builddir"
      "$swiftgen" colors "$clrfile" >"$buildfile"
    fi
}

for file in *.clr
do
    compile "$file"
done
