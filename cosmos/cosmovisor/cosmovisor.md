# Prepare bin
```
mkdir -p $HOME/.elys/cosmovisor/genesis/bin
cp elysd $HOME/.elys/cosmovisor/genesis/bin/
```

# syslink
```
ln -s $HOME/.elys/cosmovisor/genesis $HOME/.elys/cosmovisor/current
sudo ln -s $HOME/.elys/cosmovisor/current/bin/elysd /usr/local/bin/elysd
```

# install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

# Service File
```
sudo tee /etc/systemd/system/elysd.service > /dev/null << EOF
[Unit]
Description=elys-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.elys"
Environment="DAEMON_NAME=elysd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.elys/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable elysd
```
# Start Service
```
sudo systemctl start elysd && sudo journalctl -u elysd -f --no-hostname -o cat
```

# Upgrades
```
mkdir -p $HOME/.elys/cosmovisor/upgrades/0.3.1/bin
cp elysd $HOME/.elys/cosmovisor/upgrades/0.3.1/bin/
```
