# docker nginx php-8 phalcon-5
````
# run
docker run -d -p 81:80 -v /Users/sofyan/Dev/php:/app --name dinosaurus nimdasx/nginx-php8-phalcon5

# build dan push ke github
docker build --tag ghcr.io/nimdasx/nginx-php8-phalcon5 .
docker push ghcr.io/nimdasx/nginx-php8-phalcon5

# build dan push ke docker hub
docker build --tag nimdasx/nginx-php8-phalcon5 .
docker push nimdasx/nginx-php8-phalcon5

docker buildx build --platform linux/amd64 --tag nimdasx/nginx-php8-phalcon5 --push .

CR=harbor.sofy.web.id
PU=x/nginx-php8-phalcon5
docker login $CR
docker build -t $CR/$PU .
docker push $CR/$PU
docker buildx build --platform linux/amd64 --tag $CR/$PU --push . 

````