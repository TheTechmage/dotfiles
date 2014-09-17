#!/bin/bash

progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

for i in {1..16}
do
echo "Downloading http://www.epicminecraft.com/wallpapers/minecraft-wallpaper-${i}.jpg/png"
wget --progress=bar:force "http://www.epicminecraft.com/wallpapers/minecraft-wallpaper-${i}.jpg" 2>&1 | progressfilt
wget --progress=bar:force "http://www.epicminecraft.com/wallpapers/minecraft-wallpaper-${i}.png" 2>&1 | progressfilt
done
