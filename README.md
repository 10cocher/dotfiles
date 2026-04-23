# Manage dotfiles with chezmoi

Here are some guidelines to set up a local machine using [chezmoi](https://www.chezmoi.io).

## Install curl, git

We will need curl to install chezmoi
```bash
sudo apt update
sudo apt install curl
```

And we will need `git` to be able to pull the repo locally:
```
sudo add-apt-repository ppa:git-core/ppa
sudo apt update && sudo apt install git
```

Everything else will be installed by `chezmoi`.


## Install chezmoi and run installation scripts

This single command should be enough:
```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```


## Post-installation manual operations

- Create local ssh keys (following `~/.ssh/config`);
- Import gpg key.;
- Add internal docker registry to `/etc/docker/daemon.json` to bypass rate limiting policy.

To be able to use `claude-code`:
```bash
mise use --global node@latest
mise use --global npm:@anthropic-ai/claude-code
```
