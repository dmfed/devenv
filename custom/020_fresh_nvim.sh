# install neovim 0.8.0
set -e
echo "fetching neovim"
curl --location 'https://github.com/neovim/neovim/releases/download/v0.8.0/nvim.appimage' -o /usr/local/bin/nvim
chmod +x /usr/local/bin/nvim
ln -s /usr/local/bin/nvim /usr/bin/vim
echo "neovim 0.8.0 installed into /usr/local"
