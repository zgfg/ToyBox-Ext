#!/system/bin/sh

#Magisk Module ToyBox-Ext v1.0.4
#Copyright (c) zgfg @ xda, 2022-

# Module's own path (local path)
MODDIR=${0%/*}

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
TB=toybox

# Install toybox-stock binary if found in the path
TBBIN=toybox-stock
TBSTOCK=$(which $TB)
if [ ! -z "$TBSTOCK" ]
then
  cp $TBSTOCK $TBBIN
  chmod 755 $TBBIN
  Applets=$(./$TBBIN)
fi

# Create symlinks for toybox-stock applets
$Count=0
for Applet in $Applets
do
  # Skip if applet already found in the path
  Check=$(which $Applet)
  if [ -z "$Check" ]
  then
    ln -s $TBBIN $Applet
    $Count=$((Count++))
  fi
done

# Remove toybox-stock if no symlinks created
if [ "$Count" -le 0 ]
then
  rm $TBBIN
fi

# List toybox-exr applets
TBBIN=toybox-ext
Applets=$($MODDIR/$TBBIN)
Applets=$Applets$'\n'$TBBIN

# Create symlinks for toybox-ext applets
$Count=0
for Applet in $Applets
do
  # Skip if applet already found in the path
  Check=$(which $Applet)
  if [ -z "$Check" ]
  then
#    ln -s $TBBIN $Applet
    ln -s $MODDIR/$TBBIN $Applet
    $Count=$((Count++))
  fi
done
