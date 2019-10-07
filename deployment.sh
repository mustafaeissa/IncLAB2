#!/bin/bash

## Get container network
  cont_net=$(docker inspect $cont_f_name -f "{{json .NetworkSettings.Networks }}"|cut -d '"' -f2)

### Build the new container using new compose
   cat > $cont_name.v$(($cont_ver_num+1))-compose.yml <<EOF

version: '3'
services:
    $cont_name.v$(($cont_ver_num+1)):
         build: ./$Work_dir
         image: $image_name:v$(($img_ver_num+1))
         container_name: $cont_name.v$(($cont_ver_num+1))
         networks:
             - $cont_net
networks:
  $cont_net:
    external: true

EOF
  
### Run new container
  if [[ `docker-compose -f $cont_name.v$(($cont_ver_num+1))-compose.yml up -d` ]]; then
	  echo "Starting $cont_name-v$(($cont_ver_num+1)) ..."
          sleep 20s

## Editing nginx configuration to redirect the requests to the new container ...
          sed -i "s/$cont_f_name:8080/$cont_name.v$(($cont_ver_num+1)):8080/g" ./proxy/nginx.conf
          docker exec -i nginxproxy sed -i "s/$cont_f_name:8080/$cont_name.v$(($cont_ver_num+1)):8080/g" /etc/nginx/nginx.conf

## Restart the nginx service to redirect the request to the new container.
          docker exec nginxproxy nginx -s reload
 
## Remove old container
          docker stop $cont_f_name && docker rm $cont_f_name

## Update the current compose file to update all the stack
          echo $Cur_img
          sed -i "
	  s/$cont_f_name/$cont_name.v$(($cont_ver_num+1))/g 
	  s/$Cur_img/$image_name:v$(($img_ver_num+1))/g" docker-compose.yml
	  rm -f $cont_name.v$(($cont_ver_num+1))-compose.yml
  fi

