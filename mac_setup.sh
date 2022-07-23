# NOTE: Until we install iTerm2, we will use the default terminal that comes with the Macbook.
# We'll assume that the default terminal is zsh.

###################################
# Setup computer name.
###################################
sudo scutil --set HostName macbook-pro
sudo scutil --set LocalHostName gokul-macbook-pro
sudo scutil --set ComputerName gokul-macbook-pro

# Reboot the computer.
sudo shutdown -r now

###################################
# Setup basic env.
###################################
cat >> ~/.zprofile << 'ENV_SETUP'

# Basic env.
export XDG_CONFIG_HOME=~/.config

ENV_SETUP

###################################
# Setup OhMyZsh.
###################################
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# NOTE: The above command will also move the current ~/.zshrc to ~/.zshrc.pre-oh-my-zsh
#       and create a new ~/.zshrc that contains all the OhMyZsh specific configurations.

# MANUAL INSTRUCTION: Set ZSH_THEME to "agnoster" in ~/.zshrc .

# Refresh for changes to take effect.
exec $SHELL -l

###################################
# Setup SSH keys.
###################################

ssh-keygen -t ed25519 -C "gokul.r.subramanian@gmail.com"

# MANUAL INSTRUCTION: Follow https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
#                     in order to add the generated SSH keys to the GitHub account.

# MANUAL INSTRUCTION: Similarly add the SSH keys to the Bitbucket account.

# MANUAL INSTRUCTION: Add "ssh-agent" plugin to the OhMyZsh plugin list. This ensures that
#                     ssh-agent is started the first time the user logs in
#                     and adds all the available SSH keys into the agent.

# Refresh for changes to take effect.
exec $SHELL -l

###################################
# Setup git.
###################################
git config --global user.name "Gokul Ramanan Subramanian"
git config --global user.email "gokul.r.subramanian@gmail.com"

###################################
# Setup homebrew.
###################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

cat >> ~/.zprofile << 'HOMEBREW_SETUP'

# Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
HOMEBREW_SETUP

# Refresh for changes to take effect.
exec $SHELL -l

###################################
# Setup iTerm2.
###################################
brew install --cask iterm2

# Install Powerline fonts for iTerm2.
cd ~/Downloads
git clone https://github.com/powerline/fonts.git --depth 1
./fonts/install.sh 
rm -rf fonts 
cd

# MANUAL INSTRUCTION: Close terminal, open iTerm2, go to the Preferences and change
#                         - color to "Solarized Dark"
#                         - font to "Meslo LG S for Powerline"
#                         - font size to "16"
#                         - scrollback to "unlimited" 

###################################
# Install GnuPG.
###################################
brew install gnupg

###################################
# Setup search.
###################################

# Install fzf (for fuzzy searching files and past commands).
brew install fzf
/opt/homebrew/opt/fzf/install --no-bash --no-fish

# MANUAL INSTRUCTION: The above installation adds the setup scripts to .zshrc, but for performance
#                     it is better to have them in .zprofile, so manually move the setup to .zprofile.

# Refresh for changes to take effect.
exec $SHELL -l

# Install silver searcher (a better version of grep available as the command `ag`).
brew install the_silver_searcher

# Install tree (to allow visualizing the directory structure)
brew install tree

###################################
# Setup the Python programming language.
###################################

# NOTE: We install Python first, because we will depend on it later when setting up the editor.

# NOTE: We'll avoid using the system Python and instead use pyenv for managing various Python
#       versions on the system.

# Install pyenv first.
brew install pyenv
brew install pyenv-virtualenv

# Setup Python env.
cat >> ~/.zprofile << 'PYENV_SETUP'

# Python (pyenv).
export PYENV_ROOT=~/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
PYENV_SETUP

# Refresh for changes to take effect.
exec $SHELL -l

# Install Python via pyenv.
# NOTE: Pick a later Python version if available.
pyenv install 3.10.5
pyenv global 3.10.5

# Refresh for changes to take effect.
exec $SHELL -l

###################################
# Setup neovim (editor).
###################################
brew install neovim
pip install neovim # This is required by dein (plugin manager for neovim).

# Install dein (plugin manager for neovim).
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh -o /tmp/dein-installer.sh \
    && zsh /tmp/dein-installer.sh ~/.config/dein

# Fetch neovim config.
cd ~/.config
git clone git@github.com:grsubramanian/nvim-config.git nvim
touch ~/.vimrc

cat >> ~/.zshrc << 'NEOVIM_SETUP'

# nvim.
export EDITOR=$(which nvim)
alias vim="$EDITOR"
alias vimdiff="nvim -d"
NEOVIM_SETUP

# Refresh for changes to take effect.
exec $SHELL -l

# MANUAL INSTRUCTION: Run `vim` and enable dein by running `:UpdateRemotePlugins`

###################################
# Setup the Go programming language.
###################################

# MANUAL INSTRUCTION: Install Go via https://go.dev/doc/install

# Setup Go env.
cat >> ~/.zprofile << 'GO_SETUP'

# Go.
export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"
GO_SETUP

# Refresh for changes to take effect.
exec $SHELL -l

###################################
# Setup the Java programming language.
###################################

# NOTE: Java 8 does not properly install on M1 MACs, so we will stick with Java 11.

brew install openjdk@11

# Ensure that the system Java wrappers can find this JDK.
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# Setup Java env.
cat >> ~/.zprofile << 'JAVA_SETUP'

# Java.
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home)"
JAVA_SETUP

# Refresh for changes to take effect.
exec $SHELL -l

###################################
# Setup case sensitive volume for coding purposes.
###################################

diskutil apfs addVolume disk3 'Case-sensitive APFS' code -quota 50g

# Create a link so that we can easily access the volume.
ln -s /Volumes/code ~/code

###################################
# Setup Go (game) software.
###################################

# MANUAL INSTRUCTION: Install KGS client from http://files.gokgs.com/javaBin/cgoban.dmg
# MANUAL INSTRUCTION: Install Pandanet client from https://pandanet-igs.com/gopanda2/download/GoPanda2.dmg

# Install katrain (KataGo AI combined with a nice UI).
brew install katrain

