#!/bin/bash

yum install httpd -y 

systemctl start httpd 
systemctl enable httpd 


echo "<h1> Sharks Home APP is up and running</h1>" > /var/www/html/index.html 
