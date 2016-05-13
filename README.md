# dynamodb-titan-docker

https://hub.docker.com/r/soloman1124/dynamodb-titan/

Dockerfile for the dynamodb-titan-storage as described in https://github.com/awslabs/dynamodb-titan-storage-backend.

The image supports the following environment variable based configurations:
- `DYNAMODB_ENDPOINT`: set dynamodb endpoint, e.g. `http://dynamodb:8000` or `http://dynamodb.ap-southeast-2.amazonaws.com/`
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`: AWS access credentials for remote dynamodb access
- `DYNAMODB_PREFIX`: prefix for the graph related tables (default to `v100`)


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


## Connect to AWS DynamoDB

The following show example `docker-compose.yml` for actual AWS DynamoDB backend:

```
app:
  build: .
  links:
    - titan_server
  ports:
    - 5000:5000
  volumes:
    - .:/usr/src/app
titan_server:
  image: soloman1124/dynamodb-titan
  environment:
    - DYNAMODB_ENDPOINT=http://dynamodb.ap-southeast-2.amazonaws.com
    - AWS_ACCESS_KEY_ID=
    - AWS_SECRET_ACCESS_KEY=  
  ports:
    - 8182:8182
```
