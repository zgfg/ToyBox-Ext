#!/system/bin/sh

# Magisk Module: ToyBox-Ext v1.0.5
# Copyright (c) zgfg @ xda, 2022-
# GitHub source: https://github.com/zgfg/ToyBox-Ext

# Module's own path (local path)
MODDIR=${0%/*}
cd $MODDIR

# Read the original toybox binary type
source tbtype.sh

TBEXT=toybox-ext
if [ ! -z $TBTYPE ] && [ -e $TBTYPE ]
then
  # Replace toybox with the latest downloaded binary
  mv $TBTYPE $TBEXT
fi

# System XBIN path
XBINDIR=/system/xbin

# Local XBIN and (or) BIN paths for mounting
TBXBINDIR=$MODDIR$XBINDIR
TBBINDIR=$MODDIR/system/bin

# Use local XBIN path if System XBIN path exists, otherwise use local BIN path
if [ -d $XBINDIR ]
then
  TBDIR=$TBXBINDIR
else
  TBDIR=$TBBINDIR
fi

# Clean-up local XBIN and BIN paths
rm -rf $TBXBINDIR
rm -rf $TBBINDIR
mkdir -p $TBDIR
cd $TBDIR

# List toybox-stock applets if found
TB=toybox
TBSTOCK=$(which $TB)
if [ ! -z "$TBSTOCK" ]
then
  Applets=$($TBSTOCK)
fi

# Create symlinks for toybox-stock applets
for Applet in $Applets
do
  # Skip if applet already found in the path
  Check=$(which $Applet)
  if [ -z "$Check" ]
  then
    ln -s $TBSTOCK $Applet
  fi
done

# List toybox-ext applets
TBBIN=$MODDIR/$TBEXT
Applets=$TB$'\n'$TBEXT$'\n'$($TBBIN)

# Create symlinks for toybox-ext applets
for Applet in $Applets
do
  # Skip if applet already found in the path
  Check=$(which $Applet)
  if [ -z "$Check" ]
  then
    ln -s $TBBIN $Applet
  fi
done
