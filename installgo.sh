GOVER=$(curl https://go.dev/VERSION?m=text)
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/${GOVER}.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
