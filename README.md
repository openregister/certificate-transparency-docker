# Overview

[![Build Status](https://travis-ci.org/openregister/certificate-transparency-docker.svg?branch=master)](https://travis-ci.org/openregister/certificate-transparency-docker)

Creates a [Docker image](https://hub.docker.com/r/openregister/certificate-transparency/) based on Ubuntu 14.04 and installs the [Nix Package Manager](https://nixos.org/nix/), which we then use to install the [Certificate Transparency](https://github.com/google/certificate-transparency)  package.

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
$ docker run -d -p 8080:8080 openregister/certificate-transparency 
```

## Testing that it's working

```
$ curl http://192.168.99.100:8080/ct/v1/get-sth
{ "tree_size": 0, "timestamp": 1450348896926, "sha256_root_hash": "47DEQpj8HBSa+\/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=", "tree_head_signature": "BAMARjBEAiBo9fSFIFTgKNCHtwy2XTH+14Zfl3woixHMZ3uGaiYAGQIgRl\/8W2VdQgpF65+zjV3m\/aotAOnLf4ZIPVHDJVrHG24=" }

$ curl -X POST -H "Content-Type: application/json" http://192.168.99.100:8080/ct/v1/add-json -d '{}'
{ "sct_version": 0, "id": "xw5QggCXxPXD\/MdRt8jvwFHfPDOlVZjby6IcDdfGxwY=", "timestamp": 1450348938302, "extensions": "", "signature": "BAMARzBFAiAjZUVNXylv2ocLCW5d6GdNS5lhpCLamj57giw34Kx+1wIhAJ6df+DNvNItOhhdpa8y0b6YNgTC+IusejJ3xSv\/AoZr" }

$ sleep 10s

$ curl http://192.168.99.100:8080/ct/v1/get-sth
{ "tree_size": 1, "timestamp": 1450348966928, "sha256_root_hash": "RGmTWn7r56bGhLC+f0B\/0gUErdbWO6fuhBftJplPsJU=", "tree_head_signature": "BAMARzBFAiEA1bMv0QwgVbRK9eFkhmaKsNWXeYRVJKA1tSWVmBycMcECID1nKYKmFqOJ1G5VfTg2GZcAPaxevVZiDKbICzFrM0YG" }
```

