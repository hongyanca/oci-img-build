## Build a Dev Container with Python, Go, and Rust

Access the code-server web page, open terminal, install rust and pyenv again.

```
# Install rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
echo '. "$HOME/.cargo/env"' >> ~/.bashrc

# Install pyenv
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
```



