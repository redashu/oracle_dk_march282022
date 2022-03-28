# Plan 

<img src="plan.png">


## problem in bare-metal with multiple apps 

<img src="apps.png">

### VM as solution 

<img src="vms.png">

### problem in vms

<img src="vmprob.png">

## Introduction to containers

<img src="cont.png">

### vm vs container 

<img src="vmvscont.png">

## DOcker containers 

<img src="dc.png">

### Docker support 

<img src="docker.png">

### Docker Installation on OCI vm 

```
 
[root@docker-vm ~]# yum  install  docker 
Ksplice for Oracle Linux 8 (x86_64)                                                    3.8 MB/s | 708 kB     00:00    
MySQL 8.0 for Oracle Linux 8 (x86_64)                                                   24 MB/s | 2.2 MB     00:00    
MySQL 8.0 Tools Community for Oracle Linux 8 (x86_64)                                  3.3 MB/s | 249 kB     00:00    
MySQL 8.0 Connectors Community for Oracle Linux 8 (x86_64)                             238 kB/s |  20 kB     00:00    

Oracle Software for OCI users on 

=== systemctl enable --now docker 
```

### checking docker version 

```
 docker version 
Client: Docker Engine - Community
 Version:           19.03.11-ol
 API version:       1.40
 Go version:        go1.16.2
 Git commit:        9bb540d
 Built:             Fri Jul 23 01:33:55 2021
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.11-ol
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.16.2
  Git commit:       9bb540d
  Built:            Fri Jul 23 01:32:08 2021
```

### containers and its images 

<img src="darch.png">

## Docker client side Operations --

### docker image pulling 

### 

```
[ashu@docker-new-vm ~]$ docker  images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[ashu@docker-new-vm ~]$ docker  pull   mysql  
Using default tag: latest
Trying to pull repository docker.io/library/mysql ... 
latest: Pulling from docker.io/library/mysql
a4b007099961: Already exists 
e2b610d88fd9: Already exists 
38567843b438: Already exists 
5fc423bf9558: Already exists 
aa8241dfe828: Already exists 
cc662311610e: Already exists 
9832d1192cf2: Already exists 
f2aa1710465f: Already exists 
4a2d5722b8f3: Pull complete 
3a246e8d7cac: Pull complete 
2f834692d7cc: Pull complete 
a37409568022: Pull complete 
Digest: sha256:b2ae0f527005d99bacdf3a220958ed171e1eb0676377174f0323e0a10912408a
Status: Image is up to date for mysql:latest
mysql:latest
[ashu@docker-new-vm ~]$ docker  images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql               latest              562c9bc24a08        9 days ago          521MB
```

### pulling 

```
[ashu@docker-new-vm ~]$ docker  pull  oraclelinux:8.5 
Trying to pull repository docker.io/library/oraclelinux ... 
8.5: Pulling from docker.io/library/oraclelinux
00e01bb8b231: Pull complete 
Digest: sha256:0c4f3ad8df0afe5be952b9d67b7c89c772aba29bec333ec855bc8684f502fd4e
Status: Downloaded newer image for oraclelinux:8.5
oraclelinux:8.5
[ashu@docker-new-vm ~]$ docker  images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
oraclelinux         8.5                 c23ed56a9693        3 days ago          235MB
alpine              latest              9c842ac49a39        4 days ago          5.57MB
mysql               latest              562c9bc24a08        9 days ago          521MB
```

### docker image remove 

```
ashu@docker-new-vm ~]$ docker rmi   9fbf7d1c04fe 
Untagged: oraclelinux:7.5
Untagged: oraclelinux@sha256:aacb3ca22fa4089375be9b44b1cd9638fb3521695919f5a64cc833217e8c2c21
Deleted: sha256:9fbf7d1c04feccd465f9cc4295bb0172bc939952ec22c24f36de39fea43be6ae
Deleted: sha256:78e91243d69c91f6c481419254a2fcdf2e1ca642a534b90d3a0b28e416a1bad9
[ashu@docker-new-vm ~]$ 
[ashu@docker-new-vm ~]$ 
[ashu@docker-new-vm ~]$ docker  images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
oraclelinux         8.5                 c23ed56a9693        3 days ago          235MB
alpine              latest              9c842ac49a39        4 days ago          5.57MB
mysql               latest              562c9bc24a08        9 days ago          521MB
```

### COntainer process importance 

<img src="cp.png">

### Creating container 

```
 
[ashu@docker-new-vm ~]$ docker  run   --name  ashuc1   -d    alpine:latest    ping  google.com  
87d3fbdd7b6f9fbdb6e1ca9ee8656454c2223d98d366ba0c2a49778f24d09b01
```

### checking list of running container 

```
docker   ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
d1663ef5c706        alpine:latest       "ping google.com"   6 seconds ago        Up 5 seconds                            ganesh1
0c054e9ebd6b        alpine:latest       "ping google.com"   7 seconds ago        Up 6 seconds                            nmallela
b8faddc3ee36        alpine:latest       "ping google.com"   13 seconds ago       Up 12 seconds                           muthu1
d8a2660d4f07        alpine:latest       "ping google.com"   About a minute ago   Up About a minute                       db1
87d3fbdd7b6f        alpine:latest       "ping google.com"   About a minute ago   Up About a minute                       ashuc1
```

### check resource used by containers 

```
[ashu@docker-new-vm ~]$ docker  stats  ashuc1 
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT   MEM %               NET I/O             BLOCK I/O           PIDS
87d3fbdd7b6f        ashuc1              0.01%               288KiB / 15.35GiB   0.00%               37.5kB / 35.5kB     0B / 0B             1
^C

```

### to check all the containers 

```
[ashu@docker-new-vm ~]$ docker  ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
6e07f0e5e9b0        alpine:latest       "ping google.com"   26 seconds ago      Exited (0) 18 seconds ago                       satish1
b37af956f329        alpine:latest       "ping google.com"   3 minutes ago       Up 3 minutes                                    sparsh1
9d77f66c3d88        alpine:latest       "/bin/sh"           4 minutes ago       Exited (0) 4 minutes ago                        skC1
37cd6add8cc5        alpine:latest       "ping google.com"   6 minutes ago       Up 6 minutes         

```

### to check output of container parent process

```
docker  logs   ashuc1 
```

### stop a container 

```
docker  stop  ashuc1
```

### start container 

```
ashu@docker-new-vm ~]$ docker  start  ashuc1
ashuc1
```
### 
