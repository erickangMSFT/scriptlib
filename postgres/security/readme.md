create new user

```bash
sudo -u postgres createuser --superuser $USER
psql
\password
```

open port 5432


```bash
sudo ufw status verbose
sudo ufw enable 5432/tcp
```

Add in /etc/postgresql/.../pg_hba.conf
```bash
host    all             all             10.211.55.0/24          trust
```

restarting postgresql
```bash
sudo /etc/init.d/postgresql restart
```