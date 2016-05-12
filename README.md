# dynamodb-titan-docker

Dockerfile for the dynamodb-titan-storage as described in https://github.com/awslabs/dynamodb-titan-storage-backend.

The `dynamo-db` endpoint can be modified through setting `DYNAMODB_ENDPOINT`
environment variable (at `docker run`).

The following shows an example `docker-compose.yml` file:


```
app:
  build: .
  links:
    - titan_server
    - dynamodb
  ports:
    - 5000:5000
  volumes:
    - .:/usr/src/app
titan_server:
  image: soloman1124/dynamodb-titan
  links:
    - dynamodb
  environment:
    - DYNAMODB_ENDPOINT=http://dynamodb:8000
  ports:
    - 8182:8182
dynamodb:
  image: peopleperhour/dynamodb:latest
  volumes_from:
    - dynamodb_data
  ports:
    - 8000:8000
  entrypoint:
    - java
    - -Djava.library.path=.
    - -jar
    - DynamoDBLocal.jar
    - -dbPath
    - /var/dynamodb_local
    - -port
    - "8000"
dynamodb_data:
  image: peopleperhour/dynamodb:latest
  volumes:
    - ./.dynamodb_wd:/var/dynamodb_local
  entrypoint: /bin/true
```


With the example docker compose file, the following are supported:

- execute the titan server: `docker-compose up titan_server`
- execute the gremlin console: `docker-compose run titan_server console`
- execute arbitrary script in side of titan server dir:
  `docker-compose run titan_server <script_file>`  
