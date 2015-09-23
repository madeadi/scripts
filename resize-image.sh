#!/bin/bash
# traverse folder and subfolders of $1
# not traverse the subfolder if the folder name is preceeded with underscore
# then, create subfolder _$2 and copy all images into it
# Then, for each image in _$2, if image's length is more than $3, resize it to $3

folder_name="_${2}"
max_width=${3}

os=`uname -s`
if [ "$os" != "Darwin" ]; then
    `type convert >/dev/null 2>&1 || { echo >&2 "I require ImageMagick but it's not installed.  Aborting."; exit 0; }`
fi

# copy and resize image with Mac's sips command
# taking one parameter $1 = image to be resized
function create_image {
    f=$1
    extension="${f##*.}"

    if [[ "$extension" = "jpg" || "$extension" = "png" || "$extension" = "bmp" ]]
        then
        file_copy=${folder_name}/${f}
        cp "$f" "$file_copy"

        if [ "$os" = 'Darwin' ]; then
            width=`sips -g pixelWidth "$f" | tail -n1 | cut -d" " -f4`
            height=`sips -g pixelHeight "$f" | tail -n1 | cut -d" " -f4`
        else
            #with Image Magick
            width=`identify -format "%w" "$f"`
        fi

        if [ $width -gt "${max_width}" ]
            then
            #echo "Resizing ${f} from width ${width}px to ${max_width} px"

            if [ "$os" = 'Darwin' ]; then
                #with sips
                sips -Z ${max_width} "$file_copy"
            else
                #with ImageMagick
                convert "$file_copy" -resize $max_width "$file_copy"
            fi
        fi

        if [ $height -gt "${max_width}" ]
            then
            # echo "Resizing ${f} from height ${width}px to ${max_width} px"

            if [ "$os" = 'Darwin' ]; then
                #with sips
                sips -Z ${max_width} "$file_copy"
            else
                #with ImageMagick
                convert "$file_copy" -resize $max_width "$file_copy"
            fi
        fi
    fi
}

# traverse the folder $1 recursively
# create _folder if it doesn't exist
function traverse_folder {
    folder=`pwd`

    # create folder if it doesn't exist
    if [ ! -d "$folder_name" ]; then
        echo "Create $folder/$folder_name"
        mkdir -p ${folder_name}
    fi

    for d in *; do
        firstchar=${d:0:1}
        if [[ -d $d && "$firstchar" != "_" ]]; then
            (cd $d; echo "entering $d/"; traverse_folder)
        elif [[ "$firstchar" != "_" ]]; then
            # copy image if doesn't exist, or
            # if the image in the target folder is older
            target=$folder/$folder_name/$d
            printf " file: $d: "
            if [ ! -f "$target" ]; then
                create_image "$d"
                printf " resized. \n"
            elif [ "$d" -nt "$target" ]; then
                create_image "$d"
                printf " resized. Target is older \n"
            else
                printf " skipped. Target is newer. \n"
            fi
        fi
    done
}
#echo $1
cd $1

traverse_folder
