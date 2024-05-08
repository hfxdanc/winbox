# WinBox flatpak
**!!! This wrapper is not verified by, affiliated with, sponsored or supported by MikroTīk in any way. !!!**

------

Flatpak build for Mikrotik's WinBox configuration utility.  **No** MikroTik binaries are included in the flatpak. 

After agreement to the [Export Eligibility Requirements and END USER LICENSE](https://mikrotik.com/downloadterms.html) the following will be downloaded and installed ...

- Latest Windows X86_64 version of WinBox and licence terms
- MikroTik logo for the Desktop icon (will replace the default project icon) 

#### Possible issues

##### AppStream data

When the Flatpak was built, the release of latest WinBox executable was included in the "Version" section of the AppStream Desktop files; however, the install may download a newer version.

##### Fonts

- Wine seems to now *always* obey the font settings from the underlying O/S regarding antialiasing.  If you are using GNOME desktop and the fonts in WinBox appear thin and are not providing proper kerning (text is improperly spaced) check the current settings ...

  `$ dconf read /org/gnome/desktop/interface/font-antialiasing`
  `'grayscale'`
  `$`

  If the value is `'grayscale'` or `'none'` updating it with `'rgba'` vastly improves the WinBox on Wine experience ...

  `$ dconf write /org/gnome/desktop/interface/font-antialiasing "'rgba'"`
  `$ dconf read /org/gnome/desktop/interface/font-antialiasing`
  `'rgba'`
  `$`

- WinBox is coded to prefer the "default" Windows 7 Tahoma font it appears.  Wine (winehq runtime) provides a free alternative to the proprietary Microsoft typeface, but it seems to not provide proper kerning (text is improperly spaced).  Font replacement handling in Wine will always use the original font   if it is available (cannot be substituted), therefore the build removes the Wine provided Tahoma font so that a user can replace it with an alternative.

  The Fedora package `wine-tahoma-fonts` provides the WineHQ font, so if it is installed the font issue will appear.  Other Linux distributions may differ.
  
  With **no** Tahoma font installed WinBox/Wine selects an alternative from the WineHQ defaults.  Testing shows *Liberation Sans* being requested which renders acceptably.
  
  During the initial flatpak run a graphical window will display a list of  available fonts and allow one to be selected. The selection will be used to update the registry key `HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements` or clear it if  `Auto` is selected.

##### Network

- If you are not seeing any addresses in the "Neighbors" tab there may be a local firewall interfering with discovery.  On distributions using firewalld ...

  gtk-update-icon-cache -f -t /usr/share/icons/hicolor
  $ firewall-cmd --permanent --add-port=5678/udp
  $ firewall-cmd --reload

### Build

The local flatpak is assembled by the flatpak-builder tooling.  On a Fedora based distro the following packages are needed (other distros may vary) ...

`$ sudo dnf install flatpak-builder appstream-compose composefs composefs-libs ostree` 

Clone the GitHub repository ...

`$ git clone https://github.com/hfxdanc/winbox.git`

Issue the following command after cloning the repository to build and install the flatpak (in user space)

`$ cd winbox`
`$ sh update.sh`

### Run

Run the flatpak with ...

`$ flatpak run org.flatpak.WinBox`

The code installs Appstream metadata and a .desktop file in the users `$HOME` directory.  You can execute the flatpak as a normal desktop  application using the Super key.

If you are unsatisfied with the font that was selected you can update the it with the command ...

`$ flatpak run --command=/app/bin/winbox-fonts.sh org.flatpak.WinBox`

### Uninstall

You can remove the application through your normal GUI process or with the command ...

```
$ flatpak uninstall --delete-data org.flatpak.WinBox
```

The MikroTik icon downloaded during installation was installed outside of `$FLATPAK_USER_DIR` tree so that the AppStream desktop process could use it.  You can remove the icon with the command ...

`$ find $HOME/.local/share/icons/hicolor/ -name org.flatpak.WinBox.png -exec rm {} \;`
