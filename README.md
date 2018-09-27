# Packer Templates
This repo contains some [Packer](https://www.packer.io/) templates that I use for setting up VMs.

Because I don't like Packer's JSON format, the JSON is generated from a YAML template.

Although it includes some things like a "vagrant" user, the Vagrant post-processing is currently not enabled (mainly because I didn't find a nice way to conditionally enable it).

## Simple Usage Without Python Dependencies
Packer build:

    $ packer build centos7.json

If you want to only build a box for one of the supported virtualization platforms (e.g. only build the VMware box), add `--only=vmware-iso` to the `packer build` command:

    $ packer build --only=vmware-iso centos7.json
    
    $ packer build --only=virtualbox-iso centos7.json

## Development
### Python Requirements
Install Python requirements using [pipenv](https://docs.pipenv.org/):

    $ pipenv install

### Invoke Tasks
There is an [Invoke](http://www.pyinvoke.org/) script (`tasks.py`) for running common tasks.

First activate the virtualenv so Invoke is available:

    $ pipenv shell

List available tasks:

    $ inv -l

Show help for a task:

    $ inv -h build

Build VM(s):

    $ inv centos7

## License

MIT license.

## Author Information

Created in 2018 by [Sam Hartsfield](http://samhartsfield.com/).

Based on:

* https://github.com/geerlingguy/packer-centos-7
* https://github.com/geerlingguy/packer-ubuntu-1804
