#!/bin/bash

# Clean node_modules and vendor directories.
# The script will find those modules, 
# with the maxdepth of 2 level under 
# the current directory

DIR=${1?Error: no directory selected}
echo ""
echo "This will DELETE folder node_modules and vendor under the working directory."
echo "Working directoryt: $DIR"

function join_by { local IFS="$1"; shift; echo "$*"; }

exceptdir=("*immunoscape*" "*jujur*" "*app-delivery*")
except=""
echo ""
echo "Excepted directory: "
for a in ${exceptdir[@]}
do
    echo $a
    except="-o -path $a $except"
done

echo ""
while true; do
    read -p "Press y to continue, x to exit: " y
    case $y in
        [Yy]* ) break;;
        [Xx]* ) exit;;
    esac
done
# echo $except

# theexcept= ${except:3}
basescript='find $DIR \( -name "node_modules" -o -name "vendor" \) -type d -prune -maxdepth 2 -not \( ${except:3} \)'

found= eval $basescript
echo $found

echo ""
echo "Please review ONCE again the list of paths where the node_modules and vendor going to be deleted!!"
while true; do
    read -p "Press y to continue, x to exit: " y
    case $y in
        [Yy]* ) break;;
        [Xx]* ) exit;;
    esac
done

deletescript="$basescript -exec rm -rf '{}' +"
eval $deletescript
echo ""
echo "DONE!!"