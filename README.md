# scripts
My script collection

*resize-image.sh*

An image resizer. Use it like:

./resize-image.sh /replace/to/a/folder/name small_folder 500

What it does is, the image will:
- Create _small_folder to store all images + resized images
- Traverse all subfolders, except folder which name is preceeded with _ (underscore)
- Copy all images in the folder into _small_folder
- If the width of an image in _small_folder is more than 500, it will issue 'sips' command to resize the image
