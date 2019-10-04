#!/bin/bash

#1st check if a new .jar befoe create new container
#Assuming that the script argument is put in a form "dir/jar_file"

if [ -n $1 ];then

  Work_dir=$(echo $1 | cut -d/ -f1 )
  echo $Work_dir
  Current_jar=$(grep "ENV" $Work_dir/Dockerfile | awk '{print $3}')
  echo $Current_jar
  new_jar=$(echo $1 | cut -d/ -f2 )
  echo $new_jar
  if [ "$Current_jar" == "$new_jar" ];
  then
        echo "Dockerfile already updated"
  else
   # sed -i "s/$Current_jar/$new_jar/g" ./$Work_dir/Dockerfile
    #echo "jar file has been updated"
## Get Container Name & Version
  DesiredApp=$(echo $Work_dir|cut -c1-7)
  cont=$(docker ps -f name=$DesiredApp -q)
  cont_f_name=$(docker inspect "$cont" -f "{{ .Name }}"|cut -d/ -f2)
  cont_name=$(docker inspect "$cont" -f "{{ .Name }}"|cut -d/ -f2|cut -d "." -f1)
  cont_version=$(docker inspect "$cont" -f "{{ .Name }}"|cut -d/ -f2|cut -d "." -f2)
  cont_ver_num=$(echo $cont_version|cut -c2)
  echo "Current runnign cont is: $cont_f_name"

## Get Image Name & Version
  Cur_img=$(docker inspect $cont_f_name -f "{{.Config.Image}}")
  image_name=$(docker inspect $cont_f_name -f "{{.Config.Image}}"|cut -d: -f1)
  image_ver=$(docker inspect $cont_f_name -f "{{.Config.Image}}"|cut -d: -f2)
  img_ver_num=$(echo $image_ver|cut -c2)
  echo $img_ver_num

  fi
fi
