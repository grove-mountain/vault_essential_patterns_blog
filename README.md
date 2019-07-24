# vault_essential_patterns_blog
Code examples used for the Essential Patterns of Vault -- Pt 2 blog post

This can be run either on a Mac or in Vagrant directly.   Feel free to port to whatever OS you'd like to run in.

It's good to run in two windows with one running the Vault dev server and the other to run the commands.


## Mac Based
This was developed on a Mac with the following requirements installed:

- [Vault](https://www.vaultproject.io/downloads.html)
- [Docker](https://hub.docker.com/search/?type=edition&offering=community)
  - [Postgres image](https://hub.docker.com/_/postgres)
  - Custom OpenLDAP image - git clone https://github.com/grove-mountain/docker-ldap-server.git
- [jq](https://stedolan.github.io/jq/)

The scripts will automatically download the required Docker containers, so you don't need to do that upfront.   

## Vagrant based

If you're not on a Mac, you can also run this via Vagrant with the following requirements:

- [Vagrant](https://www.vagrantup.com/downloads.html)
- Virtual Machine software of Choice that Vagrant supports

### Start commands
```
vagrant up
vagrant ssh
cd /vagrant
```

## Run the demo
### First window
```
./0_launch_vault.sh
```

### Second window
This will run all the scripts in order.   Be sure to hit <return> after each command to go to the next one.
```
./run_all.sh
```

Alternatively you can run each numbered file in succession and then each test file in whichever order you please, but the suggested order is:
```
./test_it.sh
./test_engineering.sh
./test_hr.sh
```

Finish with:
```
./shutdown.sh
```
