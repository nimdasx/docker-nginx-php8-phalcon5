# catatan pribadi
````
docker run -d -p 81:80 -v /Users/sofyan/Dev/php:/app --name wedus nimdasx/nginx-php8-phalcon5
````
# build dan push ke github
````
docker build --tag ghcr.io/nimdasx/nginx-php8-phalcon5 .
docker push ghcr.io/nimdasx/nginx-php8-phalcon5
````
# build dan push ke docker hub
````
docker build --tag nimdasx/nginx-php8-phalcon5 .
docker push nimdasx/nginx-php8-phalcon5
````