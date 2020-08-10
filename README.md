# fwbackups-docker
This repo contains scripts and a Dockerfile for running fwbackups in Docker (Ubuntu 20.04)

### Prerequisites

You need the following setup:

```
Docker (tested Docker version 19.03.12, build 48a66213fe)
```

### Installing

clone this project:

```
git clone https://github.com/sh39sxn/fwbackups-docker.git
```


Build the Docker container (or use the prebuild one at my DockerHub Repo [https://hub.docker.com/r/sh39sxn/fwbackups](https://hub.docker.com/r/sh39sxn/fwbackups)):
```
cd fwbackups-docker
docker build -t fwbackups-docker:latest .
```


### Configiration of fwbackups

fwbackups provides the possiblity to configure the backups via conf files.
As an example the [backupSet1.conf](backupSet1.conf) is included in this repo.
It will compress the backup file to a tar.gz archive and keep the last 5 versions.

### Configuration of Docker Container
As fwbackups is run inside the Docker Container you usually want to save the backups on the host system.
Therefore when running the Docker container two mount points are used. 

The first one defines where to store the created backups on the host system. In this example the backups are stored in the directory "backups" which is included when cloning this repo.

```
-v /$(pwd)/backups:/backups
```

The second one defines the partition or folder you want to backup.
Therefore it's mounted to "/filesystem" inside the container. If you want to use another name you have to change the file [backupSet1.conf](backupSet1.conf).
```
-v /:/filesystem
```


### how to use

Run the Docker container (adjust the volumes mountings before if you want, see section Configuration):
```
docker run -it -e LOCAL_USER_ID=`id -u $USER` -v /$(pwd)/backups:/backups -v /:/filesystem sh39sxn/fwbackups:latest
```



## Donation
Thank's for any donations if you like this project!

Litecoin address: LdxTMGSUGLWfcULQQ6UWTNcJGGCLysefJ7

Bitcoin address: 1H7GZ2SGQcDiEcbqdimn2C9AM4VGbqrBdx

Ethereum address: 0x2a427da268c081466be59b41e0a7ad556f57e755

## Built With

* [Docker](https://www.docker.com/)
* [fwbackups](http://www.diffingo.com/oss/fwbackups)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details