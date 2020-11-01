#! /usr/bin/env bash
eval homedir=~

keytype=("OpenSSH private key")
template="# <comment>
Host <domain><alt>
	HostName <domain>
	User git
	AddKeysToAgent yes
	IgnoreUnknown UseKeychain
	UseKeychain yes
	IdentityFile ~/.ssh/<name>"

echo -e "Welcome to the GIT Multi-Account utility, Let's create a new key\n"

echo -e "This is are the keys currently in your .ssh folder\n"
if [[ ! -e ~/.ssh ]]
then
	echo ~/.ssh "doesn't exists"
	exit 1
fi

for key in ~/.ssh/*
do
	if [[ $(file $key) =~ ${keytype} ]]
	then
		if [[ -e $key.pub && -n $(cut -d' ' -f3 $key.pub) ]]
		then
			echo "• ${key##*/} → $(cut -d' ' -f3 $key.pub)"
		else
			echo "• ${key##*/} → no comment"
		fi
	fi
done
echo

read -p "Want to create a new key? (y/n): " op

if [[ $op =~ ^("N"|"n")$ ]]
then
	echo "Understandable have a great day"
	exit 1
fi

(exit 1)
while [[ $? -eq 1 ]]
do
	read -p "Add a name for the key (ex. github): " name
	echo

	ssh-keygen -t rsa -b 4096 -f "$homedir/.ssh/id_rsa-$name" -N "" -C "$(whoami)@$name"
done
echo

read -p "Where you going to use this key (ex. github.com): " domain
regex="$domain"
ow=false
while [[ $(grep -oP "Host \K(.*)" ~/.ssh/config) =~ $regex ]]
do
	read -p "An entry with this name alredy exists, want to overwrite it? (y/n): " op
	if [[ $op =~ ^("N"|"n")$ ]]
	then
		read -p "Add an aditional alias: " alt
		alt="""$(sed -e 's/^[[:space:]]*//' <<< "$alt")"""
		regex="$domain(-$alt)+"
	else
		ow=true
		break
	fi
done
echo

[[ ! -z "$alt" ]] && comment="$alt $domain" && alt="-$alt" || comment="$domain"
entry=$(sed -e "s/<comment>/$comment account/g" \
	-e "s/<domain>/$domain/g" \
	-e "s/<alt>/$alt/g" \
	-e "s/<name>/id_rsa-$name/g" <<< "$template")

if $ow
then
	echo -e "Manually replace the entry with this one:\n$entry\n"
else
	echo -e "$entry" >> ~/.ssh/config
fi

cat ~/.ssh/id_rsa-$name.pub
echo
echo "Note: Remember to replace git@$domain$alt:... when clonning" 

exit 0

