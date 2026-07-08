{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Adwaita Sans" ];
      serif = [ "Roboto Serif" ];
      monospace = [
        "Maple Mono"
        "Symbols Nerd Font Mono"
      ];
    };
    antialias = true;
    hinting.style = "slight";
    hinting.enable = true;
    subpixel.rgba = "rgb";
    subpixel.lcdfilter = "default";

    localConf = ''
      <?xml version="1.0"?>
              <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
              <fontconfig>
                <alias><family>-apple-system</family><prefer><family>Adwaita Sans</family></prefer></alias>
                <alias><family>Segoe UI</family><prefer><family>Adwaita Sans</family></prefer></alias>
                <alias><family>Georgia</family><prefer><family>Gelasio</family></prefer></alias>
                <alias><family>Latin Modern Roman</family><prefer><family>LMRoman10</family></prefer></alias>
                <alias><family>Arial</family><prefer><family>Arimo</family></prefer></alias>
                <alias><family>Calibri</family><prefer><family>Carlito</family></prefer></alias>
                <alias><family>Verdana</family><prefer><family>Bitstream Vera Sans</family></prefer></alias>
                <alias><family>SFMono-Regular</family><prefer><family>SF Mono</family></prefer></alias>
      	  <match target="font">
                    <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
                </match>
              </fontconfig>
    '';
  };

  fonts.packages = with pkgs; [
    # Adobe
    source-code-pro
    source-sans
    source-serif
    # General
    dejavu_fonts
    freefont_ttf
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    hack-font
    ibm-plex
    jetbrains-mono

    # OTF/TeX
    lmodern
    gyre-fonts

    # TTF
    ttf_bitstream_vera
    caladea
    carlito
    libertine

    # Nerd fonts (nixpkgs 25.05+)
    nerd-fonts.symbols-only
    # Adwaita (usually pulled in by GTK, but explicit)
    adwaita-fonts
    maple-mono.variable
  ];
}
