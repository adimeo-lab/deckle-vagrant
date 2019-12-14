# Deckle Vagrant

Vagrantfile for setting up a deckle VM

## Installation

After installing Vagrant (and Parallels Desktop if you're working on macOs), 
clone this repository somewhere on your development machine:

```shell script
cd /opt
git clone https://github.com/adimeo-lab/deckle-vagrant
```

Then, build the vagrant machine

```shell script
cd deckle-vagrant
vagrant up
```

## Update

If the deckle-vagrant is updated, you'll fetch the newer version using git:

```shell script
git pull origin master
```

And you will then have to provision your vm again:

```shell script
vagrant provision
```

If something goes really bad, you also can destroy your vagrant machine to provision a fresh one... 

`
But please note that doing this will get all your the data yopu may have created/imported since you firstly provision thez vagrant machine, including databases, profiles, etc.
`

```shell script
vagrant destroy
```

## Tuning

### Use the key!

As many deckle commands make use of ssh to connect to the deckle-vm, you should copy your ssh public keys in the vm, 
so that you won't be requested to type the deckle user password each time you connect to the vm using ssh.

This can be done using the following command:

```shell script
# default password is 'deckle'
ssh-copy-id deckle@deckle-vm
``` 

### Known hosts in deckle vm

To prevent some deckle commands from behaving oddly, you should add your reference server to known hosts.

This is for instance required for commands like `db:import` in Drupal8 projects.

```shell script
deckle vm:ssh:add-host remote.host.name
```


