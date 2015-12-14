# Overview

Creates a docker image based on Ubuntu 14.04 and installs the [Nix Package Manager](https://nixos.org/nix/), which we then use to install the [Certificate Transparency](https://github.com/google/certificate-transparency)  package.

Nix is multi-user aware and doesn't like running as root, so we create a 'nixuser' account which installs the CT package. If you use the default entrypoints, you'll need to change to this user and source the CT variables (see Running section below).

## Building

```
docker build -t openregister/certificate-transparency
```

If you're a member of the openregister organisation on Docker Hub, then you can push a changed image up via

```
docker push openregister/certificate-transparency
```

Note that there's no automated build from GitHub at this point - need to investigate the permissions.

## Running

```
$ docker run -it openregister/certificate-transparency /bin/bash
root@2d77cb0acc73:/# su nixuser
nixuser@2d77cb0acc73:/$ cd
nixuser@2d77cb0acc73:~$ . /home/nixuser/.nix-profile/etc/profile.d/nix.sh
nixuser@2d77cb0acc73:~$ ct
ct <command> ...
Known commands:
connect - connect to an SSL server
upload - upload a submission to a CT log server
certificate - make a superfluous proof certificate
extension_data - convert an audit proof to TLS extension format
configure_proof - write the proof in an X509v3 configuration file
diagnose_chain - print info about the SCTs the cert chain carries
wrap - take an SCT and certificate chain and wrap them as if they were
       retrieved via 'connect'
wrap_embedded - take a certificate chain with an embedded SCT and wrap
                them as if they were retrieved via 'connect'
get_roots - get roots from the log
get_entries - get entries from the log
sth - get the current STH from the log
consistency - get and check consistency of two STHs
monitor - use the monitor (see monitor_action flag)
Use --help to display command-line flag options
```

