#!/system/bin/sh

# Magisk Module: ToyBox-Ext v1.0.6
# Copyright (c) zgfg @ xda, 2022-
# GitHub source: https://github.com/zgfg/ToyBox-Ext

# Module's own path (local path)
MODDIR=${0%/*}
cd $MODDIR

# Source the original toybox binary type
TBSCRIPT='./tbtype.sh'
if [ -f $TBSCRIPT ]
then
  . $TBSCRIPT
fi

# ToyBox-Ext
TBEXT=toybox-ext
if [ ! -z $TBTYPE ] && [ -f $TBTYPE ]
then
  # Replace toybox-ext with the latest downloaded binary
  mv $TBTYPE $TBEXT
fi

# System XBIN path
XBINDIR=/system/xbin
BINDIR=/system/bin

# Local XBIN and (or) BIN paths for mounting
TBXBINDIR=$MODDIR$XBINDIR
TBBINDIR=$MODDIR$BINDIR

# Use local XBIN path if System XBIN path exists, otherwise use local BIN path
if [ -d $XBINDIR ]
then
  SDIR=$XBINDIR
  TBDIR=$TBXBINDIR
else
  SDIR=$BINDIR
  TBDIR=$TBBINDIR
fi

# Clean-up local XBIN and BIN paths
rm -rf $TBXBINDIR
rm -rf $TBBINDIR
mkdir -p $TBDIR
cd $TBDIR

# Stock toybox
TB=toybox
TBSTOCK=$(which $TB)
if [ ! -z "$TBSTOCK" ]
then
  TBPATH=$(echo "$TBSTOCK" | sed "s,/$TB$,,")
fi

# List toybox-ext applets
TBBIN=$MODDIR/$TBEXT
Applets=$TB$'\n'$TBEXT$'\n'$($TBBIN)

# Create symlinks for toybox-ext applets
for Applet in $Applets
do
  # Skip if applet already found in the path
  Check=$(which $Applet)
  if [ -z "$Check" ] && [ ! -x "$SDIR/$Applet" ] && [ ! -x "$TBPATH/$Applet" ]
  then
	# Create symlink
    ln -s $TBBIN $Applet
  fi
done

# List toybox-stock applets if found
Applets=""
if [ ! -z "$TBSTOCK" ]
then
  Applets=$TB$'\n'$($TBSTOCK)
fi

# Create symlinks for toybox-stock applets
for Applet in $Applets
do
  # Skip if applet already found in the path
  Check=$(which $Applet)
  if [ -z "$Check" ] && [ ! -x "$SDIR/$Applet" ] && [ ! -x "$TBPATH/$Applet" ]
  then
	# Create symlink
    ln -s $TBSTOCK $Applet
  fi
done
