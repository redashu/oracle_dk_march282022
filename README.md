# Plan 

<img src="plan.png">

## Docker Networking

<img src="dnet.png">

### docker network commands 

```
 docker network ls 
NETWORK ID          NAME                DRIVER              SCOPE
aed9392c4333        bridge              bridge              local
7c7eef41f349        host                host                local
43691b97d25c        none                null                local
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ docker network  inspect  aed9392c4333 
[
    {
        "Name": "bridge",
        "Id": "aed9392c43330f694adada0304782d67b221704b11e3ba957a4d8c445235d40f",
        "Created": "2022-03-30T05:10:22.075828391Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"

```

### creating bridge 

```
 273  docker network  create  ashubr1 
  274  docker network  inspect  ashubr1
  275  history 
[ashu@docker-new-vm myimages]$ docker network ls 
NETWORK ID          NAME                DRIVER              SCOPE
3aeffea456d5        ashubr1             bridge              local
aed9392c4333        bridge              bridge              local
f6c183369703        ganeshbr1           bridge              local
7c7eef41f349        host                host                local
```

### containers from same bridge can connect to each other 

```
 docker  exec -it  ashuc1  sh 
/ # 
/ # ifconfig 
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:13 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1086 (1.0 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ # ping  172.17.0.4
PING 172.17.0.4 (172.17.0.4): 56 data bytes
64 bytes from 172.17.0.4: seq=0 ttl=64 time=0.126 ms
64 bytes from 172.17.0.4: seq=1 ttl=64 time=0.064 ms
64 bytes from 172.17.0.4: seq=2 ttl=64 time=0.062 ms
64 bytes from 172.17.0.4: seq=3 ttl=64 time=0.074 ms
64 bytes from 172.17.0.4: seq=4 ttl=64 time=0.068 ms
64 bytes from 172.17.0.4: seq=5 ttl=64 time=0.066 ms
^C
--- 172.17.0.4 ping statistics ---
6 packets transmitted, 6 packets received, 0% packet loss
round-trip min/avg/max = 0.062/0.076/0.126 ms
/ # 
```
### by default container from different bridge can't communicate 

```
 docker  run -itd --name  ashuc2 --network ashubr1  alpine
d99ee27f31e6e568ff6b20bfbd5cdcb80dfffeb7fde4663e61ea4a4bfc43e7cc
[ashu@docker-new-vm myimages]$ docker exec -it  ashuc2  sh 
/ # ping  172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
^C
--- 172.17.0.2 ping statistics ---
9 packets transmitted, 0 packets received, 100% packet loss
/ # exit
```
### create bridge delete 

```
 docker network  create  ashubr2 --subnet 192.168.1.0/24 
fe5bd6ce6986e5da0bb84416ef6bd1cf22f8c5af0f0865ed7bc3a6ee2f259d7a
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ docker  network rm ashubr2
ashubr2
```
### in custom bridge DNS in containers also working 

```
[ashu@docker-new-vm myimages]$ docker run -itd --name ashuc1 --network ashubr2  alpine 
c5b80726949cf9ceb5b82fe396b150910c3422d6e53f5f71314733ed317b282a
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ docker run -itd --name ashuc2 --network ashubr2 --ip 192.169.101.10  alpine 
f125fd5c33ff32225bbf95f11f84a18289c69f1cc9d838be4a764d31f3a3134a
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ 
[ashu@docker-new-vm myimages]$ docker  exec -ti ashuc1  sh 
/ # ping  ashuc2
PING ashuc2 (192.169.101.10): 56 data bytes
64 bytes from 192.169.101.10: seq=0 ttl=64 time=0.103 ms
64 bytes from 192.169.101.10: seq=1 ttl=64 time=0.063 ms
64 bytes from 192.169.101.10: seq=2 ttl=64 time=0.058 ms
^C
--- ashuc2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.058/0.074/0.103 ms
/ # exit
```

## webapp 

<img src="webapp.png">

### Docker build image 

```

$ ls  -a
.   deploy.sh   .dockerignore    project-html-website
..  Dockerfile  html-sample-app  project-website-template
[ashu@docker-new-vm customer]$ docker  build  -t  customer:ashuappv1  . 
Sending build context to Docker daemon  3.934MB
Step 1/13 : FROM oraclelinux:8.4
Trying to pull repository docker.io/library/oraclelinux ... 
8.4: Pulling from docker.io/library/oraclelinux
a4df6f21af84: Pull complete 
Digest: sha256:b81d5b0638bb67030b207d2858

```

### creating container without env 

```
docker run -itd --name ashuc1 -p 1111:80 customer:ashuappv1
a28cb6afb0e03418532729e89debb91b6f452adf7f715d48fd01abdd11e8bbc1
[ashu@docker-new-vm customer]$ docker  exec ashuc1 env 
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=a28cb6afb0e0
app=hello
HOME=/root

```
### storage 

<img src="st.png">

### create volume 

```
ashu@docker-new-vm myimages]$ docker  volume  create  ashuvol1 
ashuvol1
```

### list volumes 

```
 docker  volume  lsDRIVER              VOLUME NAME
local               ashuvol1
local               skvol1

 docker  volume  inspect ashuvol1 
[
    {
        "CreatedAt": "2022-03-30T10:58:23Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/ashuvol1/_data",
        "Name": "ashuvol1",
        "Options": {},
        "Scope": "local"
    }
]


```

### create volume 

```
docker  run -it --name ashuc1  -v  ashuvol1:/data:rw  alpine 
/ # 
/ # 
/ # ls 
bin    dev    home   media  opt    root   sbin   sys    usr
data   etc    lib    mnt    proc   run    srv    tmp    var
/ # cd  /data/
/data # ls
/data # mkdir  hello docker  
/data # ls
docker  hello
/data # touch a.txt 
/data # ls
a.txt   docker  hello
/data # exit
[ashu@docker-new-vm myimages]$ docker rm ashuc1
ashuc1
[ashu@docker-new-vm myimages]$ docker  run --name ashuc2 -it -v ashuvol1:/new:ro  oraclelinux:8.4 
[root@b9d4c9a86f3c /]# 
[root@b9d4c9a86f3c /]# 
[root@b9d4c9a86f3c /]# ls
bin   dev  home  lib64  mnt  opt   root  sbin  sys  usr
boot  etc  lib   media  new  proc  run   srv   tmp  var
[root@b9d4c9a86f3c /]# cd  /new/
[root@b9d4c9a86f3c new]# ls
a.txt  docker  hello
[root@b9d4c9a86f3c new]# mkdir hiii
mkdir: cannot create directory 'hiii': Read-only file system
[root@b9d4c9a86f3c new]# exit
exit
```
