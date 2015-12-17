FROM ubuntu:14.04
MAINTAINER Andrew Gorton

# Update the system
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y curl

# Add the nixuser for Nix Package Management
RUN groupadd -g 10000 nixuser
RUN useradd -m -g nixuser -G sudo,users -u 10000 nixuser
RUN echo "nixuser:nixuser" | chpasswd
RUN echo "nixuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nixuser

# Install NIX
USER nixuser
WORKDIR /home/nixuser
RUN curl -o webinstall.sh https://nixos.org/nix/install
RUN chmod u+x /home/nixuser/webinstall.sh
RUN ["/bin/sh", "-l", "-c", "USER=nixuser /home/nixuser/webinstall.sh"]

# Install CT
RUN . /home/nixuser/.nix-profile/etc/profile.d/nix.sh && nix-channel --add https://nixos.org/channels/nixos-unstable nixos
RUN . /home/nixuser/.nix-profile/etc/profile.d/nix.sh && nix-channel --update
RUN . /home/nixuser/.nix-profile/etc/profile.d/nix.sh && nix-env -iA nixos.certificate-transparency

# Tidyup - remove password-free sudo capability
RUN rm /home/nixuser/webinstall.sh
USER root
WORKDIR /
RUN rm /etc/sudoers.d/nixuser
RUN echo "nixuser:$(openssl rand -base64 32)" | chpasswd

RUN openssl ecparam -out ct.key -name secp256r1 -genkey
RUN openssl ec -in ct.key -pubout -out ct.pem
EXPOSE 8080
ENTRYPOINT . /home/nixuser/.nix-profile/etc/profile.d/nix.sh && xjson-server --port=8080  --guard_window_seconds=5 --tree_signing_frequency_seconds=10  --leveldb_db=/data --key=ct.key --i_know_stand_alone_mode_can_lose_data
