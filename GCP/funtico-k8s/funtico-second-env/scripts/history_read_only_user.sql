-- Database 'funtico_history_db' add readonly user

CREATE USER 'USER'@'%' IDENTIFIED BY 'PASSWORD';
GRANT SELECT, SHOW VIEW ON *.* TO 'USER'@'%';
FLUSH PRIVILEGES;
