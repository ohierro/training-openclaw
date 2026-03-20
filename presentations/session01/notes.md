# Session 01 notes

## Instalación de máquina virtual

Olvidar...
sudo apt update
sudo apt install -y dkms build-essential linux-headers-generic virtualbox-guest-x11

sudo mkdir -p /media/cdrom
sudo mount /dev/cdrom /media/cdrom
sudo /media/cdrom/VBoxLinuxAdditions.run


check: lsmod | grep vboxguest


* Cambiar la configuración de red a bridge

## 2 instalaciones

Nativo

https://docs.openclaw.ai/install

Docker

https://docs.openclaw.ai/install/docker

Pasos:
* Instalar docker: https://docs.docker.com/engine/install/ubuntu/
* hay que añadir github a know_hosts
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts


### Con imagen externa
Podemos probar con OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest

OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest ./docker-setup.sh

## Configuración

Vamos a usar https://openrouter.ai/

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

https://openrouter.ai/docs/guides/coding-agents/openclaw-integration

Discord: MTQ4NDA5Mjc4NDc2Njg4MTg3Mg.GUd7HJ.-EKcQ8cvLwgLGyxjw_XqwZbWq65Cpbnr0vu2Hg


