# Login

```bash
docker exec -it storage-mysql-1 sh -c 'mysql -uroot -p$MYSQL_PASSWORD --default-character-set=utf8'
docker-compose --profile tools run --rm mysql-cli
```
