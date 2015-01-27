#!/bin/sh
# traverse folder and subfolders of $1
# not traverse the subfolder if the folder name is preceeded with underscore
# then, create subfolder _$2 and copy all images into it
# Then, for each image in _$2, if image's length is more than $3, resize it to $3

folder_name="_${2}"
max_width=${3}

# copy and resize image with Mac's sips command
# taking one parameter $1 = image to be resized
function create_image {
    f=$1
    extension="${f##*.}"
    if [[ "$extension" = "jpg" || "$extension" = "png" || "$extension" = "bmp" ]]
        then
        file_copy=${folder_name}/${f}
        cp ${f} ${folder_name}/${f}

        width=`sips -g pixelWidth $f | tail -n1 | cut -d" " -f4`

        if [ $width -gt "${max_width}" ]
            then
            echo "Resizing ${f} from width ${width}px to ${max_width} px"
            sips -Z 1024 ${file_copy}
        fi
    fi
}

# traverse the folder $1 recursively
# create _folder if it doesn't exist
function traverse_folder {
    folder=`pwd`
    echo "Create $folder/$folder_name"
    mkdir -p ${folder_name}

    for d in *; do
        firstchar=${d:0:1}
        if [[ -d $d && "$firstchar" != "_" ]]; then
            (cd $d; echo "entering $d"; traverse_folder)
        elif [[ "$firstchar" != "_" ]]; then
            create_image ${d}
        fi
    done
}

cd $1
traverse_folder
