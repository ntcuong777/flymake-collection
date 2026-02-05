if ! command -v go >/dev/null; then
  apt-get update && apt-get install -y golang-go
fi

GOBIN=/usr/local/bin go install github.com/bcarrell/joker@latest
