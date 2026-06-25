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

However, in the case of a machine that is shared with other user, to keep
the `chezmoi` binary in the `${HOME}` folder instead of `/usr/bin/curl`:
```console
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b ~/.local/bin
chezmoi init https://github.com/$GITHUB_USERNAME/dotfiles.git
chezmoi apply --exclude scripts
```


## Post-installation manual operations

- Create local ssh keys (following `~/.ssh/config`);
- Import gpg key.;
- Replace the placeholders for usernames (`@` should be replaced by `%40`) and PAT in ~/.git-credentials;
- Add internal docker registry to `/etc/docker/daemon.json` to bypass rate limiting policy.



## gpg keys common operations
- To check the status (expiration, in particular) of the gpg keys:
```console
gpg --list-secret-keys --keyid-format=long
```
The key id is the string right after `rsa4096/`.
- To renew the expiration of a given gpg key:
```console
gpg --edit-key KEY_ID
```
Then type `expire`, choose the extension duration and then `save`.
To also edit the secondary key: `key 1`, and then apply the same procedure.
- To export a gpg key (to a password manager) and import it in another laptop:
```console
gpg --export-secret-keys -a KEY_ID > renewed_key.asc
gpg --import renewed_key.asc
```

To understand the shorthands:
- `S` stands for Signing.
- `C` stands for Certifying.
- `E` stands for Encryption.
