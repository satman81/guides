
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

# rate limit 2

```
rpc.domain.com {
    reverse_proxy localhost:36xx
    rate_limit {
        zone rpc_limit {
            #key {remote_host}
            events 1000
            window 300s
            burst 100
        }
    }
}
```
# Basic Auth
https://cyberhost.uk/basic-auth-caddy/<br>
https://caddyserver.com/docs/caddyfile/directives/basicauth

# Bind address

```
a.example.com {
	bind 192.168.33.11

	reverse_proxy somewhere:8080
}

b.example.com {
	bind 192.168.33.33

	reverse_proxy elsewhere:8080
}
```

# Troubleshoot

if 
sudo caddy fmt /etc/caddy/Caddyfile

> Error: Caddyfile:11: Caddyfile input is not formatted (or similar)

then:
```
sudo caddy fmt --overwrite --diff /etc/caddy/Caddyfile
```
