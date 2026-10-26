# SDKMAN! Homebrew Tap

A Homebrew tap containing the Formula for the SDKMAN! CLI.

## Installation

```sh
$ brew tap avoidik/sdkman
$ brew install sdkman-cli
```

After successful installation add the following lines to the end of your `.bash_profile`

```sh
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
```

Open a new terminal and type

```sh
sdk version
```

The output should look similar to this

```sh
SDKMAN!
script: 5.24.0
native: 0.8.0
```
