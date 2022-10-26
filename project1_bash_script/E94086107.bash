#!/bin/bash
# build missing list, wrong list and classfieing files

# missing list | wrong list
missing="missing_list"
wrong="wrong_list"

## build file
cp student_id ${missing}
cp student_id ${wrong}

## build folder
folders[0]="compressed_files/zip"
folders[1]="compressed_files/rar"
folders[2]="compressed_files/tar.gz"
folders[3]="compressed_files/unknown"

for folder in ${folders[*]}
do
    if [ ! -d ${folder} ]; then
        mkdir ${folder}
    fi
done

## compare
students=$(ls -F compressed_files/ | grep -v \/$)
for student in ${students}
do
    name=${student%%.*}
    ext=${student#*.}
    ## delete exist
    sed -i "/${name}/d" ${missing}
    ## delete correct
    if [ ${ext} = "zip" ] || [ ${ext} = "rar" ] || [ ${ext} = "tar.gz" ]; then
        sed -i "/${name}/d" ${wrong}
    fi
done

## unzip
mv compressed_files/*.zip ${folders[0]}
unzip "${folders[0]}/*.zip" -d ${folders[0]}

## unrar
mv compressed_files/*.rar ${folders[1]}
unrar x "${folders[1]}/*.rar" ${folders[1]}


## tar.gz
mv compressed_files/*.tar.gz ${folders[2]}
for tar in ${folders[2]}/*.tar.gz
do
    tar xvf $tar -C ${folders[2]}
done 

mv compressed_files/*.* ${folders[3]}
#move out tar.gz/
mv ${folders[3]}/tar.gz ${folders[2]}

exit 0