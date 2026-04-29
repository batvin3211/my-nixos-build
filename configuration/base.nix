# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running "nixos-help").

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # UEFI boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.netbootxyz.enable = true;

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # boot logo
  boot.plymouth.enable = true;

  # ZRAM
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback broadcom_sta ];
  boot.kernelModules = [ "sg" "wl" ];
  
  # blacklist similar modules to avoid collision
  boot.blacklistedKernelModules = [ "b43" "bcma" ];

  networking.networkmanager.enable = true;

  # blocklist
  networking.stevenblack.enable = true;
  networking.stevenblack.block = [ "fakenews" "gambling" ];

  # Set your time zone.
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  fonts.packages = [ pkgs.corefonts ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  environment.cosmic.excludePackages = [ pkgs.cosmic-player ];
  #programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
  };
  services.xserver.xkb.options = "grp:win_space_toggle";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip splix ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  programs.noisetorch.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.vincent = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "lp" "audio" "video" "cdrom" "input" "libvirtd" "dialout" ];
  };
  programs.fish.enable = true;

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  nixpkgs.config.allowInsecurePredicate = pkg:
    builtins.elem (lib.getName pkg) [
    "broadcom-sta"
    "electron"
  ];
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      tailscale
      trayscale
      bleachbit
      btop
      git
      caligula
      gnome-disk-utility
      system-config-printer
      fastfetch
      topgrade
      appimage-run
      gearlever
      vaults
      varia
      # cosmic DE
      cosmic-ext-tweaks
      # editors
      nano
      # vm
      quickemu
      quickgui
      # containers
      podman
      podman-compose
      distrobox
      boxbuddy
      # office apps
      libreoffice
      celluloid
      # package manager
      wget
      # web browser
      brave
    ];
  };

  programs.captive-browser.enable = true;
  programs.captive-browser.bindInterface = false;

  # brave config
  environment.etc."/brave/policies/managed/GroupPolicy.json".source = ./brave-policies.json;
  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    ];
  };

  # flatpak
  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # podman
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # bluetooth
  hardware.bluetooth.enable = true;

  # dconf
  programs.dconf.enable = true;

  # enable the tailscale service
  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # auto clean
  nix.optimise.automatic = true;

  # enable fwupd
  services.fwupd.enable = true;

  # auto update
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  system.autoUpgrade.randomizedDelaySec = "45min";
  system.autoUpgrade.operation = "boot";
  system.autoUpgrade.runGarbageCollection = false;
  nix.settings.auto-optimise-store = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
     22
  ];
  #networking.firewall.allowedUDPPorts = [
  #];
  networking.firewall.allowedTCPPortRanges = [
     {
       from = 1714;
       to = 1764;
     }
  ];
  networking.firewall.allowedUDPPortRanges = [
     {
       from = 1714;
       to = 1764;
     }
  ];
  # networking.firewall.rejectPackets = true;
  # networking.firewall.allowedUDPPorts = [ 21116 ];
  # Or disable the firewall altogether.
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  services.fail2ban.enable = true;
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were
  # taken. It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read
  # the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

