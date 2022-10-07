# catatan pribadi
````
docker run -d -p 81:80 -v /Users/sofyan/Dev/php:/app --name terserah nimdasx/docker-nginx-php8-phalcon5
docker rm -f terserah
````
# build dan push ke hub docker 
````
docker build --tag nimdasx/docker-nginx-php8-phalcon5 .
docker push nimdasx/docker-nginx-php8-phalcon5
````
# build dan push ke github
````
docker build --tag ghcr.io/nimdasx/docker-nginx-php8-phalcon5:main .
docker push ghcr.io/nimdasx/docker-nginx-php8-phalcon5:main
````
