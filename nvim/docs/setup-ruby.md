## 1. Remove System Ruby & Reset Paths
```bash
sudo apt remove ruby ruby-full rubygems bundler -y
sudo rm -rf /usr/bin/ruby /usr/bin/gem /usr/local/bin/bundle /var/lib/gems
```

## 2. Install rbenv & ruby-build
```bash
sudo apt update && sudo apt install -y git curl build-essential libssl-dev libreadline-dev zlib1g-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Create symlinks for rbenv
sudo ln -s ~/.rbenv/bin/rbenv /usr/local/bin/rbenv

# Install ruby-build plugin
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

## 3. Install Ruby 3.2.2 & Bundler
```bash
# Install ruby 3.2.2 & Bundler
rbenv install 3.2.2
rbenv global 3.2.2
rbenv rehash

# Create symlink for ruby
sudo ln -s ~/.rbenv/shims/ruby /usr/local/bin/ruby

# Install Bundler
gem install bundler
```

## 4. Install Ruby LSPs in Mason 
```bash
# In case it doesn't work, remove ruby-lsp and only use solargraph
:MasonInstall ruby-lsp solargraph
```

## 5. Usage
To use Ruby LSP you need to create basic Gemfile in project.
```Gemfile
group :development do
  gem "ruby-lsp"
end
```
