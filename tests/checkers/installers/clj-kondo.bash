apt-get update && apt-get install -y unzip

curl -sSL -o /tmp/clj-kondo.zip \
  https://github.com/clj-kondo/clj-kondo/releases/latest/download/clj-kondo-linux-amd64.zip
unzip -q /tmp/clj-kondo.zip -d /usr/local/bin
chmod +x /usr/local/bin/clj-kondo
