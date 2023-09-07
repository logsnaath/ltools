docker run -d nginx
docker ps

docker kill $(docker ps -ql)
docker ps

