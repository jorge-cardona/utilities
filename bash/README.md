# Bash Utilities

Here are some utilities to use in bash.

### Git Multi-Account

The git-multiacc.sh script helps you with the creation and configuration of new
keys to use on your different proyects.

Example:
```
╭jcardona@github:utilities/bash(main)
╰►$ bash git-multiacc.sh 
Welcome to the GIT Multi-Account utility, Let's create a new key

This is are the keys currently in your .ssh folder

• id_rsa-github → jcardona@github

Want to create a new key? (y/n): y
Add a name for the key (ex. github): work

Generating public/private rsa key pair.
Your identification has been saved in /home/jcardona/.ssh/id_rsa-work
Your public key has been saved in /home/jcardona/.ssh/id_rsa-work.pub
The key fingerprint is:
SHA256:[REDACTED] jcardona@work
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|   [REDACTED]    |
|                 |
+----[SHA256]-----+

Where you going to use this key (ex. github.com): github.com
An entry with this name alredy exists, want to overwrite it? (y/n): n
Add an aditional alias: work

ssh-rsa [REDACTED] jcardona@work

Note: Remember to replace git@github.com-work:... when clonning


```

