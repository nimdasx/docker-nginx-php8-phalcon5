# docker nginx php-8.1 phalcon-5.1
## catatan
````
docker run -d -p 81:80 -v /Users/sofyan/Dev/php:/app --name dinosaurus nimdasx/nginx-php8-phalcon5
````
## build dan push ke github
````
docker build --tag ghcr.io/nimdasx/nginx-php8-phalcon5 .
docker push ghcr.io/nimdasx/nginx-php8-phalcon5
````
## build dan push ke docker hub
````
docker build --tag nimdasx/nginx-php8-phalcon5 .
docker push nimdasx/nginx-php8-phalcon5
````