{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ];

    system.stateVersion = "24.05";
    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    networking.hostName = "nix";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Moscow";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    users.users.phtea = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" ];
	shell = pkgs.bash;
	packages = with pkgs; [
	    firefox
	    neovim
	    git
	    unzip
	    wget
	    rofi
	];
    };

    security.sudo.enable = true;

    services.xserver.enable = true;
    services.xserver.windowManager.i3.enable = true;
    services.xserver.displayManager.startx.enable = true;
    services.xserver.xkb.layout = "us";

    services.pipewire = {
	enable = true;
	audio.enable = true;
	alsa.enable = true;
	pulse.enable = true;
    };

    fonts.packages = with pkgs; [
	fontconfig
	nerd-fonts.fira-code
	nerd-fonts.jetbrains-mono
	noto-fonts-emoji
    ];

    environment.systemPackages = with pkgs; [
	xclip
	ghostty
	neovim
	firefox
	git
	htop
	zsh
	tmux
	xterm
	rofi
	i3status
	dmenu
	stow
	gcc
	gnumake
	vim_configurable
	ripgrep
	fastfetch
	scrot
	telegram-desktop
	discord
	picom
	tree
	feh
	xss-lock
	i3lock
	xorg.xinit
	xorg.xset
	xfce.thunar
	mpv
	polybar
	playerctl
	pamixer
	brightnessctl
	fzf
	fzf-obc
	i3ipc-glib
	jsoncpp
    ];

	#    nixpkgs.overlays = [
	# (final: prev: {
	#     polybar = prev.polybar.override {
	# 	i3Support = true;
	#     };
	# })
	#    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
