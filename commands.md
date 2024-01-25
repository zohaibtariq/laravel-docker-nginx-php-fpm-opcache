docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up
