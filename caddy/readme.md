
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

domain.com {
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
# Basic Auth
https://cyberhost.uk/basic-auth-caddy/<br>
https://caddyserver.com/docs/caddyfile/directives/basicauth

# Troubleshoot

if 
sudo caddy fmt /etc/caddy/Caddyfile

> Error: Caddyfile:11: Caddyfile input is not formatted (or similar)

then:
```
sudo caddy fmt --overwrite --diff /etc/caddy/Caddyfile
```
