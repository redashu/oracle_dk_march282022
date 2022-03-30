#!/bin/bash

if  [  "$app" == "webapp1" ]
then
    cp -rf /common/webapp1/*  /var/www/html/
    httpd -DFOREGROUND 
    
elif [  "$app" == "webapp2" ]
then
    cp -rf /common/webapp2/*  /var/www/html/
    httpd -DFOREGROUND

elif [  "$app" == "webapp3" ]
then
    cp -rf /common/webapp3/*  /var/www/html/
    httpd -DFOREGROUND

else 
    echo "This is Wrong check var name or value " >/var/www/html/index.html
    httpd -DFOREGROUND
fi 
