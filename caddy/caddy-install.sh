#https://github.com/satman81/guides/blob/main/caddy/readme.md
# Basic Version
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy


# custom caddy with rate limit support
# https://caddyserver.com/docs/build#package-support-files-for-custom-builds-for-debianubunturaspbian
#Install GO

mkdir ~/caddy && cd ~/caddy
wget https://github.com/caddyserver/xcaddy/releases/download/v0.3.2/xcaddy_0.3.2_linux_amd64.tar.gz
tar xvf xcaddy_0.3.2_linux_amd64.tar.gz
./xcaddy build --with github.com/mholt/caddy-ratelimit
# a caddy binary will be created in current dir

sudo dpkg-divert --divert /usr/bin/caddy.default --rename /usr/bin/caddy
sudo mv ./caddy /usr/bin/caddy.custom
sudo update-alternatives --install /usr/bin/caddy caddy /usr/bin/caddy.default 10
sudo update-alternatives --install /usr/bin/caddy caddy /usr/bin/caddy.custom 50

# You can change between the custom and default caddy binaries by executing and following the on screen information.
update-alternatives --config caddy
