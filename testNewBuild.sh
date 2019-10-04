#!/bin/bash

#1st check if a new .jar befoe create new container
#Assuming that the script argument is put in a form "dir/jar_file"

if [ -n $1 ];then

  export Work_dir=$(echo $1 | cut -d/ -f1 )
   echo $Work_dir
  export Current_jar=$(grep "ENV" $Work_dir/Dockerfile | awk '{print $3}')
   echo $Current_jar
  export new_jar=$(echo $1 | cut -d/ -f2 )
   echo $new_jar
  if [ "$Current_jar" == "$new_jar" ];
  then
        echo "Dockerfile already updated"
  else
   # sed -i "s/$Current_jar/$new_jar/g" ./$Work_dir/Dockerfile
   # echo "jar file has been updated"
## Get Container Name & Version
  DesiredApp=$(echo $Work_dir|cut -c1-7)
  cont=$(docker ps -f name=$DesiredApp -q|sed -n '1p' )
  export cont_f_name=$(docker inspect "$cont" -f "{{ .Name }}"|cut -d/ -f2)
  export cont_name=$(docker inspect "$cont" -f "{{ .Name }}"|cut -d/ -f2|cut -d "." -f1)
  export cont_version=$(docker inspect "$cont" -f "{{ .Name }}"|cut -d/ -f2|cut -d "." -f2)
  export cont_ver_num=$(echo $cont_version|cut -c2)
  echo "Current runnign cont is: $cont_f_name"
  #Running_Jfile=$(docker exec -i $cont_f_name bash -c env|grep APP|cut -d '=' -f2)
  echo $Running_Jfile
## Get Image Name & Version
  Cur_img=$(docker inspect $cont_f_name -f "{{.Config.Image}}")
  export image_name=$(docker inspect $cont_f_name -f "{{.Config.Image}}"|cut -d: -f1)
  export image_ver=$(docker inspect $cont_f_name -f "{{.Config.Image}}"|cut -d: -f2)
  export img_ver_num=$(echo $image_ver|cut -c2)
  echo $img_ver_num
## Check if .jar file has been included in any previous images
  for i in $(seq 1 $img_ver_num); do
      echo $i
      echo $image_name
      echo $image_name:v$i
      if ! [[ `docker inspect "$image_name:v$i" -f "{{.Config.Env}}" | grep $new_jar` ]]; then
	     # echo "$new_jar has been included in image before"
	     sed -i "s/$Current_jar/$new_jar/g" ./$Work_dir/Dockerfile
	      echo "jar file has been updated"
	      bash -x ./deployment.sh2
      else
	    # bash -x ./deployment.sh2
	    echo "$new_jar has been included in image before" 
      fi
  done

  fi
fi
