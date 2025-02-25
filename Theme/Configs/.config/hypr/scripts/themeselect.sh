#!/bin/bash

## set variables ##
BaseDir=$(dirname "$(realpath "$0")")
ThemeCtl="$HOME/.config/swww/wall.ctl"
#ThumbDir="$HOME/.config/swww/Themes-Ctl"
CacheDir="$HOME/.config/swww/.cache"
RofiConf="$HOME/.config/rofi/themeselect.rasi"
ThemeSet="$HOME/.config/hypr/themes/theme.conf"

# override rofi border
hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $ThemeSet | sed 's/ //g'`
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))
r_override="element {border-radius: ${elem_border}px;} element-icon {border-radius: ${icon_border}px;}"

# launch rofi menu
ThemeSel=$( cat $ThemeCtl | while read line
do
    thm=`echo $line | cut -d '|' -f 2`
    wal=`echo $line | awk -F '/' '{print $NF}'`
    #echo $thm $wal
    echo -en "$thm\x00icon\x1f$CacheDir/${thm}/${wal}\n"
done | rofi -dmenu -theme-str "${r_override}" -config $RofiConf)

# apply theme
if [ ! -z $ThemeSel ] ; then
    ${BaseDir}/themeswitch.sh -s $ThemeSel
fi


