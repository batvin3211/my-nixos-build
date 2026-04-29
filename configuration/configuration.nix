{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./base.nix
    ];
  # Change hostname
  networking.hostName = "nixos"; # Define your hostname.

  # Change US keyboard layout
  #services.xserver.xkb.variant = "colemak";

  # Change password
  ## To set a new password comment "password" and uncomment and "hashedPassword".
  ## Then generate a new password hash with this command "mkpasswd -m sha-512 -S 'password salt'"
  ## you can use a shortend version of your hostname without "-"
  users.users.vincent.password = "password";
  #users.users.vincent.hashedPassword = ""; 

  # user installed apps
  users.users.vincent.packages = with pkgs; [
    # chat
    #ferdium
    # 3D Printing Software
    #orca-slicer
    #freecad
    # Remote Desktop Software
    #rustdesk-flutter
    # Podcast Downloader
    #gpodder
    # Media Digitizing Software
    #kdePackages.k3b
    #makemkv
    #handbrake
    # school
    #cisco-packet-tracer_9
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Uncomment to Enable Displaylink
  #services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # Nixos channel
  #system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
  system.autoUpgrade.flake = "github:batvin3211/my-nixos-build#installed";

}
