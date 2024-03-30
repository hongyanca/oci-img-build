# AWS Command Line Interface (AWS CLI) Container Image



This image is built from https://hub.docker.com/_/amazonlinux. It includes aws cli, util-linux, unzip, zsh, and nano. There are 3 pre-created users: alice, bob, and charlie. These users can be used to test AWS cross-account access using different profiles.



## Build the image

```shell
docker build -t aws-cli-env .
```



## Multi-arch build

```shell
export CPU_ARCH=`lscpu | grep Architecture | grep -Eo 'aarch64|x86_64' | sed 's/x86_64/amd64/g' | sed 's/aarch64/arm64/g'`
wget https://github.com/docker/buildx/releases/download/v0.9.1/buildx-v0.9.1.linux-$CPU_ARCH
mkdir -p ~/.docker/cli-plugins/
mv buildx-v0.9.1.linux-$CPU_ARCH ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
docker buildx install
docker buildx ls
ls -al /proc/sys/fs/binfmt_misc/
docker run --privileged --rm tonistiigi/binfmt --install all
ls -al /proc/sys/fs/binfmt_misc/
docker buildx create --use --name mybuilder
docker buildx inspect mybuilder --bootstrap

docker buildx prune
docker buildx build --platform linux/arm64,linux/amd64 -t [TAG] . --push

docker buildx imagetools inspect [TAG]
```



## Run and access the container

```shell
docker run -it --rm --name awscli -d aws-cli-env
docker exec -it --user root awscli /usr/bin/zsh
```



## Copy credentials from host to the container

```shell
docker cp [CREDENTIALS] awscli:/root/.aws/

docker cp [CREDENTIALS] awscli:/home/alice/.aws/
docker exec -it awscli chown alice:alice /home/alice/.aws/credentials
```



## Delete credentials from the container

```shell
docker exec -it awscli rm -rf /root/.aws/credentials
docker exec -it awscli rm -rf /home/alice/.aws/credentials
docker exec -it awscli rm -rf /home/bob/.aws/credentials
docker exec -it awscli rm -rf /home/charlie/.aws/credentials
```



## Credits:

- buildx: https://github.com/docker/buildx
- amazonlinux: https://hub.docker.com/_/amazonlinux