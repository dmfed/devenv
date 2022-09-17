# install vanilla Go 1.18.6
set -e
echo "fetching go compiler"
curl --location https://go.dev/dl/go1.18.6.linux-amd64.tar.gz -o /tmp/go.tar.gz
echo "unpacking go compiler..."
tar -xzf /tmp/go.tar.gz -C /usr/local
echo "removing archive"
rm /tmp/go.tar.gz
ln -s /usr/local/go/bin/* /usr/bin
echo "Go 1.18.6 installed into /usr/local"
