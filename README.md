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
- Add internal docker registry to `/etc/docker/daemon.json` to bypass rate limiting policy.

`~/.git-credentials` is generated automatically by `private_dot_git-credentials.tmpl`,
which fetches the GitHub and Azure DevOps PATs from Proton Pass / Bitwarden at apply
time — no manual editing needed, but both CLIs must be logged in first (see below).


## Bitwarden and Proton Pass CLI

For Proton Pass CLI
```console
pass-cli login --interactive
pass-cli test
pass-cli logout

pass-cli session create-lock --idle-timeout=600
pass-cli session lock
pass-cli session unlock
pass-cli session remove-lock
```

For Bitwarden, on a machine with a browser:
```console
bw login --sso   # will ask for the org's SSO identifier (company's name)
bw lock
bw unlock         # prompts for the master password interactively, never pass it as an argument
bw logout
```

On a **headless/remote machine**, the SSO browser flow can't complete (no browser to
open, no way to receive the redirect). Use a personal API key instead:

1. Web vault → Settings → Security → Keys → "View API key" (re-enter your master
   password) to get a `client_id` / `client_secret`.
2. On the remote machine, read the secret without it landing in shell history:
   ```console
   read -rs BW_CLIENTSECRET
   export BW_CLIENTSECRET
   export BW_CLIENTID="user.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   bw login --apikey
   ```
3. `bw unlock` still prompts for the master password (never stored) to get a session —
   this login is one-time; you don't need to redo step 2 after a reboot, only if the
   API key is rotated.

`chezmoi apply` already has `[bitwarden] unlock = "auto"` configured in
`.chezmoi.toml.tmpl`, so it calls `bw unlock` and prompts for the master password
automatically whenever `BW_SESSION` isn't set — no manual `bw unlock` needed day-to-day.


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


## Emacs: ghostel native module

`claude-code-ide` uses `ghostel` as its terminal backend. `ghostel`'s native
module (`ghostel-module.so`) is supposed to download automatically on first
use, but loading the package at startup (via `use-package :ensure t`) doesn't
trigger that — you'll see `Warning (ghostel): Native module not found: ...`
on launch. Run this once manually to fetch it:
```
M-x ghostel-download-module
```
Then restart Emacs.
