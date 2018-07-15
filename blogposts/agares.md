# agares, a multi armed demon
well, originally i don't think the multi armed part was mentioned in the "list of demons" i found on the internet. now, though, agares is absolutely multi armed because I keep adding so much bullshit to this project.

* sync my dot files. .emacs, bash, powershell, etc.
* configure windows devices. install software, some minor software configuration, remove windows bullshit.
* sync my keyboard config; this involves updating a .png as well as a folder of .json an .kll files to apply firmware to ergodox.
* house deployments for home projects

Up next is configuring an Mac device, and then whatever else I get to throw at it.

## dot file sync
I think I'm doing this poorly. So far all i'm really doing is configuring all devices *actual* dot files to load these `agares/` dotfiles. 

* powershell: make sure you don't have powershell, vscode /ise, and pwsh.exe all looking for the same profile. you'll hate yourself. split them up.
* .emacs: this is pretty straightforward unless you use more emacs features than me (easy to do). I leave in just a single .emacs file. 
* .bashrc: there's a complicated set of rules that determines, at least on mac, when different .bash* files get loaded. be careful that yours only loads when you want it
* .tmux: straight forward. 
* conemu: i don't have an elegant solve for this. I just import this file whenever I set up a new machine. there is likely a better way.

### further .bashrc info
I found [this](http://hayne.net/MacDev/Notes/unixFAQ.html#shellStartup) link very useful, quoted below:  
When a "login shell" starts up, it reads the file "/etc/profile" and then "~/.bash_profile" or "~/.bash_login" or "~/.profile" (whichever one exists - it only reads one of these, checking for them in the order mentioned).

When a "non-login shell" starts up, it reads the file "/etc/bashrc" and then the file "~/.bashrc".

Note that when bash is invoked with the name "sh", it tries to mimic the startup sequence of the Bourne shell ("sh"). In particular, a non-login shell invoked as "sh" does not read any dot files by default. See the bash man page for details. 

What this means is that you don't want to link or load the agares .bashrc file from .bashrc *necessarily*. It depends on your usage. you'll likely wanna call it from .bash_profile instead, if you're on a mac.

## configure windows devices
3rd party app install is all handled through chocolatey. this is a great / terrible tool for this. great because it actually exists (wonderful!). Terrible because of certain usability problems. some packages install very weirdly through. emacs, for instance; do you want emacs? or emacs64? Those are not just optimized for different cpus, but are actually different versions of emacs (24 vs 25) that have different features shipped natively. 

### removing windows kruft
windows, particularly windows10, now ships with a bunch of bullshit that no sane person wants on their fucking computer. fucking 3rd party games are my favorite. thanks msft, get the fuck out. I stole a bunch of functions from [this](https://gist.github.com/alirobe/7f3b34ad89a159e6daa1) gist (which stole them from another). I definitely recommend perusing powershell module file i made before running the functions therein. Some are easy wins, or simple "get started" features, like removing a game or unpinning stuff from the start menu. Some are more hit or miss, like disabling the windows store; great 90% of the time IME, but if you didn't have WSL you *must* have the windows store or you can't install it.

### a note on hypervisors
i do a lot of work on hyper-v, especially recently, because there's a great suite of automation tools that work natively on that platform. hyperv is a fine tool for many things, particularly home labbing, but far less useful as a "need to run second OS without dual boot" utility. If you need that you'll likely need something like vmware workstation or virtualbox. the bad news is *you cannot have hyperv and another hypervisor active on the same machine at the same time*. hyperv blocks other hypervisors from working because its petty and rude (something about the way it operates does this. for more information on this check out [this superuser answer](https://superuser.com/questions/1208850/why-vitualbox-or-vmware-can-not-run-with-hyper-v-enabled-windows-10)).

## keyboard firmware sync
i use an [infinity ergodox](https://www.massdrop.com/buy/infinity-ergodox) at home. this is a fun entry level diy project that taught me to solder (badly) and introduced me to QMK and TMK. I avoid having to dive very deep into those and instead use input.club's online [configurator tool](https://input.club/configurator-ergodox/). i download the output and put them into the keyboard dir of `agares`, along with a screenshot of the configurator tool, so that I know how everything is *currently* configured. this helps especially early on when you're tweaking the keymap every few days trying to remember "where the fuck did i put the _ sign??". 

Once that's downloaded you still have to flash your ergodox. do yourself a favor and keep a "flash" keybinding easily accessible on both sides of your keyboard or you will hate yourself.

Some guides say you only need to flash one side of the keyboard as long as they are plugged into each other. That has never worked for me and I *must* flash both sides or the keymap will be incorrect.

### flashing the keyboard on windows
i absolutely can not get this to work unless i'm running a linux guest in virtualbox. instead, I flash from a mac or other *nix computer because its just hilariously easy and I don't have to fuck with loading a new driver first. sorry for this terrible answer, but for the infinity ergodox this is literally the easiest way. if anyone knows one for the love of god please [email me](mailto:me@jowj.net).

### flashing the keyboard on *nix
[read this here poast](https://www.reddit.com/r/MechanicalKeyboards/comments/5bjtt8/guide_infinity_ergodox_linux_guide_modifying/)

## deployments for home projects
right now this is really just a spot for my deployment of `mojojojo-bot`, my slackbot. you can read more about it (in an out of date blog post) [here](/blogposts/mojojojo-bot.md).

I deploy it using ansible targeting one of my few docker hosts. right now those are all local. eventually, i hope to build out a spot, or a deployment mechanism, for pushing it to Azure or AWS. I call `mojo.yml` with ansible-playbook, referencing a custom inventory file of `hosts.yml`, with `--ask-vault-pass` to prompt for password to decrypt `mojo-vault-vars.yml`, containing the slack-bot API token. this allows me to sync the actual API token via github, encrypted, without worrying about everyone and their dog fucking with my slack server.