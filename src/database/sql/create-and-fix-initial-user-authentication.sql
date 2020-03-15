CREATE USER  docker@'%' identified with mysql_native_password by 'banana pijama';
grant All privileges on *.* to docker@'%';
