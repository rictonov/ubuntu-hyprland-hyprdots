#!/bin/bash



# set variables
ThemeSet="$HOME/.config/hypr/themes/theme.conf"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
CurTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
WallPath="$HOME/.config/swww/$CurTheme"
CacheDir="$HOME/.config/swww/.cache"

# override rofi border
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
elem_border=$(( hypr_border * 3 ))
r_override="element {border-radius: ${elem_border}px;} listview {columns: 6;spacing: 100px;} element {padding: 0px; orientation: vertical;} element-icon {size: 418px; border-radius: 0px;} element-text {padding: 20px;}"

# launch rofi menu
RofiSel=$( ls $WallPath | while read rfile
do
    echo -en "$rfile\x00icon\x1f${CacheDir}/${CurTheme}/${rfile}\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)

# apply wallpaper
if [ ! -z $RofiSel ] ; then
    $HOME/.config/hypr/scripts/swwwallpaper.sh -s $WallPath/$RofiSel
fi
