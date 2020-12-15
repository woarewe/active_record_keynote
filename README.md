# DB Setup

```shell
docker pull postgres:12.2
docker container create --name active_record_sucks_pg --publish 5432:5432 --env POSTGRES_USER=active_record_sucks --env POSTGRES_PASSWORD=active_record_sucks  postgres:12.2
bin/rails db:create && bin/rails db:migrate
bin/rails db:seed
```


