
# Simple Version
```
nano /etc/caddy/Caddyfile

domain.com {
        reverse_proxy :36657
}

sudo systemctl reload caddy
sudo service caddy restart
sudo journalctl -xe -u caddy -f -o cat | ccze -A

```

# rate limit version

```
nano /etc/caddy/Caddyfile
{
        order rate_limit before basicauth
}

services.tecnodes.network {
        log
        root * /var/www/html
        file_server
        rate_limit {
                distributed
                zone static_example {
                        key static
                        events 10 (means 5 attempts)
                        window 1m
                }
        }
}

```

