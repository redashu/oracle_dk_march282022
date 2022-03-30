FROM oraclelinux:8.4
LABEL email=ashutoshh@linux.com
ENV app=hello
# to create ENV variable with some value
RUN yum install httpd -y 
RUN mkdir /common /common/webapp1 /common/webapp2 /common/webapp3
COPY html-sample-app /common/webapp1/
COPY  project-html-website /common/webapp2/
COPY project-website-template  /common/webapp3/
COPY deploy.sh /common/
WORKDIR /common
RUN chmod +x deploy.sh 
EXPOSE 80
ENTRYPOINT ["./deploy.sh"]

#  httpd -DFOREGROUND to start apache httpd app server 
# ENTRYPOINT is a replace of CMD 
