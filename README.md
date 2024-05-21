# WinBox flatpak
**!!! This wrapper is not verified by, affiliated with, sponsored or supported by MikroTīk in any way. !!!**

------

Flatpak build for Mikrotik's WinBox configuration utility.  **No** MikroTik binaries are included in the flatpak. 

After agreement to the [Export Eligibility Requirements and END USER LICENSE](https://mikrotik.com/downloadterms.html) the following will be downloaded and installed ...

- Latest Windows X86_64 version of WinBox and licence terms

#### Possible issues

##### AppStream data

- When the Flatpak was built, the release of latest WinBox executable was included in the "Version" section of the AppStream Desktop files; however, the install may download a newer version.

- AppStream **requires** an icon to be present.  A default free icon (included in source code) is installed upon build into the flatpak and becomes R/O.  Some tooling will always display the icon contained in the flatpak instead of using the search path.

##### Fonts

- Wine seems to now *always* obey the font settings from the underlying O/S regarding anti-aliasing.  If you are using GNOME desktop and the fonts in WinBox appear thin and are not providing proper kerning (text is improperly spaced) check the current settings ...

  `$ dconf read /org/gnome/desktop/interface/font-antialiasing`
  `'grayscale'`
  `$`

  If the value is `'grayscale'` or `'none'` updating it with `'rgba'` vastly improves the WinBox on Wine experience ...

  `$ dconf write /org/gnome/desktop/interface/font-antialiasing "'rgba'"`
  `$ dconf read /org/gnome/desktop/interface/font-antialiasing`
  `'rgba'`
  `$`

- It appears that WinBox is coded to prefer the "default" Windows 7 Tahoma font.  Wine (winehq runtime) provides a free alternative to the proprietary Microsoft typeface, but it seems to not provide proper kerning (text is improperly spaced).  Font replacement handling in Wine will always use the original font  if it is available (cannot be substituted), therefore the build removes the Wine provided Tahoma font so that a user can replace it with an alternative.

  The Fedora package `wine-tahoma-fonts` provides the WineHQ font.  If it is installed the font issue will appear.  Other Linux distributions may differ.
  
  During the initial flatpak run if an acceptable Tahoma font is found the install will skip to the final steps.
  
  With **no** Tahoma font installed a graphical window will display a list of available fonts and allow one to be selected. The selection will be used to update the registry key `HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements` or clear it if  `Auto` is selected.
  
  Use of the `Auto` preset (recommended) has been tested to show WinBox/Wine will select the *Liberation Sans* font which renders acceptably.

##### Network

- If you are not seeing any addresses in the "Neighbours" tab there may be a local firewall interfering with discovery.  On distributions using firewalld ...

  `$ sudo firewall-cmd --permanent --add-port=5678/udp`
  `$ sudo firewall-cmd --reload`

##### Icons

- If the "Terms and Conditions" are accepted the MikroTik icons contained in the WinBox application will be extracted and installed into the user's `~/.local/share/icons` directory.  Gnome caches Appstream icons, but they will be refreshed on subsequent runs.  If you wish to force the update ...

  `$ gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor`

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

The WinBox icon extracted during installation was installed outside of `$FLATPAK_USER_DIR` tree and therefore will not be removed by the uninstall process.  You can remove the icon with the command ...

`$ find $HOME/.local/share/icons/hicolor/ -name org.flatpak.WinBox.png -exec rm {} \;`
