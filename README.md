# nixos-auto-installer

Build recipe for an unattended, offline capable USB-bootable NixOS installer to bootstrap random computers.

I typically use this to "transform" random computers to minimally setup NixOS machines by putting in my USB stick and boot from it.
Afterward, the machine can be rebootet and then i can deploy whatever config i want over it from remote via SSH.
The system is really just meant as a trampoline for installing "real" system configs from remote.

## Usage

**Warning:** The created USB stick is destructive in the sense that it deletes everything on the disk without asking!

1. Build the ISO image via `nix build`
2. `dd` the ISO image over a USB stick
3. Put the USB stick into a machine that is set up to boot via USB
4. Let the machine boot and wait until it powers off again. (It typically takes ~5 minutes)
5. NixOS is now installed. Just SSH into it.

## Install in VM for testing

Run `nix build .#install-demo && ./result`

## Installation Scheme

The installer [partitions the disk](https://github.com/tfc/nixos-auto-installer/blob/main/installer.nix#L35) like this:

- 512 MiB fat32 boot partition
- 2 GiB swap partition
- rest size xfs nixos partition

The default user is 'vincent' and the default password is 'password'

Unfree modules for wifi are added in order to enable the machine's wifi on first boot.

## Post Install
- edit `/etc/nixos/configuration.nix`
- change the options for:
  - hostname 
  - keyboard layout
  - password
  - uncomment user apps.
  - nixos channel "if needed"