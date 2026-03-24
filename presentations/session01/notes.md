
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

## VirtualBox

Listar VMs (sin GUI)

VBoxManage list runningvms

Obtener datos:

VBoxManage guestproperty enumerate OpenClaw


### Con imagen externa
Podemos probar con OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest

OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:latest ./docker-setup.sh

## Configuración

Vamos a usar https://openrouter.ai/

API: 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

https://openrouter.ai/docs/guides/coding-agents/openclaw-integration

Discord: MTQ4NDA5Mjc4NDc2Njg4MTg3Mg.GUd7HJ.-EKcQ8cvLwgLGyxjw_XqwZbWq65Cpbnr0vu2Hg


Qué pasa si falla..?

## Modelo 

https://openrouter.ai/

## Cancelo setup a medias??



## Conectar a openclaw


Hay que explicar qué es el gateway el cli, diferencias...
Hay que explicar los hooks (los pide en la instalación)
    │
◆  Enable hooks?
│  ◻ Skip for now
│  ◻ 🚀 boot-md (Run BOOT.md on gateway startup)
│  ◻ 📎 bootstrap-extra-files
│  ◻ 📝 command-logger
│  ◻ 💾 session-memory

Comentar el tema del config override

Config overwrite: /home/node/.openclaw/openclaw.json (sha256 70206a2649c026269d7d82dfd28dfc1435bd014394233ac871e7b2b424637e94 -> fb6fe0d0b992990e4c6c0b4f318f7632d79a0eab7fcc01df8d5278f4712142e1, backup=/home/node/.openclaw/openclaw.json.bak)


◇  Install missing skill dependencies
│  Skip for now
│
◇  Set GOOGLE_PLACES_API_KEY for goplaces?
│  No
│
◇  Set GEMINI_API_KEY for nano-banana-pro?
│  No
│
◇  Set NOTION_API_KEY for notion?
│  No
│
◇  Set OPENAI_API_KEY for openai-image-gen?
│  No
│
◇  Set OPENAI_API_KEY for openai-whisper-api?
│  No
│
◆  Set ELEVENLABS_API_KEY for sag?


Integrar mailtrap.io ??
