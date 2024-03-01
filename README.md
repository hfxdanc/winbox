# WinBox flatpak
**!!! This wrapper is not verified by, affiliated with, sponsored or supported by MikroTīk in any way. !!!**

Flatpak build for Mikrotik WinBox configuration utility.

No binaries are included in the flatpak.  After agreement of terms the Windows X86_64 version of WinBox.exe along with the MikroTik logo will be downloaded and installed.

WinBox is coded to only request the "default" Windows 7 Tahoma font it appears.  Wine (winehq runtime) provides a free alternative to the proprietary Microsoft typeface, but it seems to not provide proper kerning and text can be improperly spaced.  Font replacement handling in Wine will always use the original font if available, therefore the build removes the Wine provided Tahoma font.

During the initial `flatpak run` a graphical window will display Tahoma alternatives that have been discovered and allow one to be selected.  If a selection has been made the registry key `HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements`  will be updated appropriately.

Windows 10 updated the "default" font from Tahoma to Segoe.  A git repository https://github.com/mrbvrz/segoe-ui-linux.git currently contains a copy. 

The manifest will add any TrueType fonts that have been copied into the `./fonts` directory in the source tree into the resulting flatpak.

To build the flatpak issue the following commands after cloning the repository ...

`$ sh update.sh`

Run the flatpak with ...

`$ flatpak run org.flatpak.WinBox`

The code installs Appstream metadata and a .desktop file so you can always execute the flatpak as a normal desktop  application using the Super key.

If you are unsatisfied with the font you selected you can redo the installation phase with the command ...

`$ flatpak run --command=/app/bin/winbox-fonts.sh org.flatpak.WinBox` 

Alternatively you could remove the application's data to re-invoke the initial configuration script ...

`$ rm -rf ~/.var/app/org.flatpak.WinBox/`
