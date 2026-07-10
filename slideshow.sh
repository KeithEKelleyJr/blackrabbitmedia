sudo rm -r /home/br/Pictures/Slides/blackrabbitmedia

cd /home/br/Pictures/Slides
git clone https://github.com/KeithEKelleyJr/blackrabbitmedia.git

#!/bin/sh
cd /home/br/Pictures/Slides/blackrabbitmedia
#!feh -Z -z -F -D 60 --hide-pointer --auto-rotate
find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | sort -V | xargs feh -Z -z -F -D 60 --hide-pointer --auto-rotate
