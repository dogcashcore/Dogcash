#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

PRODUCTIONCHAIND=${PRODUCTIONCHAIND:-$SRCDIR/dogcashd}
PRODUCTIONCHAINCLI=${PRODUCTIONCHAINCLI:-$SRCDIR/dogcash-cli}
PRODUCTIONCHAINTX=${PRODUCTIONCHAINTX:-$SRCDIR/dogcash-tx}
PRODUCTIONCHAINQT=${PRODUCTIONCHAINQT:-$SRCDIR/qt/dogcash-qt}

[ ! -x $PRODUCTIONCHAIND ] && echo "$PRODUCTIONCHAIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
DCHVER=($($PRODUCTIONCHAINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for dogcashd if --version-string is not set,
# but has different outcomes for dogcash-qt and dogcash-cli.
echo "[COPYRIGHT]" > footer.h2m
$PRODUCTIONCHAIND --version | sed -n '1!p' >> footer.h2m

for cmd in $PRODUCTIONCHAIND $PRODUCTIONCHAINCLI $PRODUCTIONCHAINTX $PRODUCTIONCHAINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${DCHVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${DCHVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
