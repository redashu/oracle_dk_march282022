# Plan 

<img src="plan.png">

## docker revision 

<img src="rev.png">

  
## Docker scripting using Compose by Docker 

<img src="compose.png">

### Installing docker compose for clients and checking version 

[Docker compose](https://docs.docker.com/compose/install/)

### checking 

```
docker-compose  version 
docker-compose version 1.29.2, build 5becea4c
docker-py version: 5.0.0
CPython version: 3.7.10
OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
```
 
 ### compose file example 1 
 
 ```
 version: '3.8'
services: # about container apps 
 ashuapp1: 
  image: alpine
  container_name: ashuc1
  command: ping fb.com
  restart: always 
 ```
 
 ### run compose 
 
 ```
 cd  ashucomposefiles/
[ashu@docker-new-vm ashucomposefiles]$ ls 
docker-compose.yaml
[ashu@docker-new-vm ashucomposefiles]$ docker-compose up -d
Creating network "ashucomposefiles_default" with the default driver
Creating ashuc1 ... done
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  ps
 Name      Command     State   Ports
------------------------------------
ashuc1   ping fb.com   Up           
 ```
 
### more compose commands

```
]$ docker-compose ps 
 Name      Command     State   Ports
------------------------------------
ashuc1   ping fb.com   Up           
[ashu@docker-new-vm ashucomposefiles]$ ls
docker-compose.yaml
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  stop 
Stopping ashuc1 ... done
[ashu@docker-new-vm ashucomposefiles]$ 
[ashu@docker-new-vm ashucomposefiles]$ 
[ashu@docker-new-vm ashucomposefiles]$ docker-compose ps 
 Name      Command      State     Ports
---------------------------------------
ashuc1   ping fb.com   Exit 137        
[ashu@docker-new-vm ashucomposefiles]$ 
```

### clean up 

```
 docker-compose  down 
Stopping ashuc1 ... done
Removing ashuc1 ... done
Removing network ashucomposefiles_default
```

### Compose file 2 

```
version: '3.8'
services: # about container apps 
 ashuapp2:
  image: dockerashu/customerapp:30thmarch2022
  container_name: ashuc2
  environment: # giving env data 
   app: webapp3  
  ports: # port forwarding like in docker run -p 1234:80 
  - "1234:80"
  restart: always 
 ashuapp1: 
  image: alpine
  container_name: ashuc1
  command: ping fb.com
  restart: always 
```

### run 

```
 ls
ashu.yaml  docker-compose.yaml
[ashu@docker-new-vm ashucomposefiles]$ docker-compose -f ashu.yaml  up -d
Creating network "ashucomposefiles_default" with the default driver
Creating ashuc2 ... done
Creating ashuc1 ... done
[ashu@docker-new-vm ashucomposefiles]$ docker-compose -f ashu.yaml  ps
 Name      Command     State          Ports        
---------------------------------------------------
ashuc1   ping fb.com   Up                          
ashuc2   ./deploy.sh   Up      0.0.0.0:1234->80/tcp
```

### more 

```
docker-compose  -f ashu.yaml  up -d
ashuc2 is up-to-date
ashuc1 is up-to-date
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  -f ashu.yaml   ps
 Name      Command     State          Ports        
---------------------------------------------------
ashuc1   ping fb.com   Up                          
ashuc2   ./deploy.sh   Up      0.0.0.0:1234->80/tcp
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  -f ashu.yaml   kill
Killing ashuc1 ... done
Killing ashuc2 ... done
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  -f ashu.yaml   start
Starting ashuapp2 ... done
Starting ashuapp1 ... done
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  -f ashu.yaml   ps
 Name      Command     State          Ports        
---------------------------------------------------
ashuc1   ping fb.com   Up                          
ashuc2   ./deploy.sh   Up      0.0.0.0:1234->80/tcp
[ashu@docker-new-vm ashucomposefiles]$ docker-compose  -f ashu.yaml   down 
Stopping ashuc1 ... done
Stopping ashuc2 ... done
Removing ashuc1 ... done
Removing ashuc2 ... done
Removing network ashucomposefiles_default
```

### compose file 

```
version: '3.8'
services:
 ashuwebapp:
  image: ashuweb:v007 # image i want to build 
  build: . # location of dockerfile 
  container_name: ashuwebc1
  restart: always
  environment:
   app: webapp2 
  ports:
  - 7744:80 
```

## webUI 

```
docker  run -itd --name webui -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock    --restart  always portainer/portainer
```

