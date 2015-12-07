# Thunar Custom Actions

[![Build Status](https://travis-ci.org/cytopia/thunar-custom-actions.svg?branch=master)](https://travis-ci.org/cytopia/thunar-custom-actions)

The following actions can also be used in nautilus or any other file manager that supports custom actions.
I personally prefer thunar because of speed.


If any of the actions don't work anymore (especially the upload ones), please report here, so I can fix it.

## Setup

All actions require the `-f` parameter which specifies the file to work on. Prior Thunar/Nautilus integration you can test them all on the command line to make sure they do what they are supposed to do:
```bash
thunar-action.sh -f /path/to/file
```


## Actions

### Multimedia

#### ![Thunar Convert to PNG](/icons/thunar-convert-to-png.png) [thunar-convert-to-png.sh](thunar-convert-to-png.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action converts any image file to a png image. (Should also work with layered PSD files).  
**GUI:** No output  
**Requirements:** `convert`

#### ![Thunar Convert to JPG](/icons/thunar-convert-to-jpg.png) [thunar-convert-to-jpg.sh](thunar-convert-to-jpg.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action converts any image file to a jpg image. (Should also work with layered PSD files).  
**GUI:** No output  
**Requirements:** `convert`

#### ![Thunar Media Info](/icons/thunar-media-info.png) [thunar-media-info.sh](thunar-media-info.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action pops up a zenity-based window and displays encoding information for an audio or video file.  
**GUI:** [Zenity dialog](https://help.gnome.org/users/zenity/stable/)  
**Requirements:**  `zenity` and `ffmpeg`

---

### Security

#### ![Thunar GPG Encrypt](/icons/thunar-gpg-encrypt.png) [thunar-gpg-encrypt.sh](thunar-gpg-encrypt.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action pops up a zenity-based window letting you choose from your gpg recipients and encrypts and signs the file with your chosen gpg key. (Asymmetric encryption).  
**GUI:** [Zenity dialog](https://help.gnome.org/users/zenity/stable/)   
**Requirements:**  `gpg`, `zenity` and `pinentry-gtk-2`

#### ![Thunar GPG Decrypt](/icons/thunar-gpg-decrypt.png) [thunar-gpg-decrypt.sh](thunar-gpg-decrypt.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action pops up a terminal window for password entry and decrypts the file with your private gpg key. (Asymmetric encryption).  
**TODO:** Make gui-based password entry form.  
**GUI:** No output  
**Requirements:**  `gpg`

#### ![Thunar GPG Info](/icons/thunar-gpg-info.png) [thunar-gpg-info.sh](thunar-gpg-info.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action pops up a zenity-based window and displays information about the encryption of the current file. (Asymmetric encryption).  
**GUI:** [Zenity dialog](https://help.gnome.org/users/zenity/stable/)  
**Requirements:**  `gpg` and `zenity`

---

### Uploads

#### ![Thunar Paste to Gist](/icons/thunar-paste-to-gist.png) [thunar-paste-to-gist.sh](thunar-paste-to-gist.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action pastes a text file to gist (in private mode) and pops up a zenity-based window displaying the paste url (shortened). Additionally the paste url will also be copied to clipboard.  
**GUI:** [Zenity dialog](https://help.gnome.org/users/zenity/stable/)  
**Requirements:** `zenity` and `gist`

#### ![Thunar Paste to Pastebin](/icons/thunar-paste-to-pastebin.png) [thunar-paste-to-pastebin.sh](thunar-paste-to-pastebin.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  
This action pastes a text file to pastebin and pops up a zenity-based window displaying the paste url.  
**NOTE:** The pastebin API only allows 25 pastes per free account per every 24 hours. I have added two API keys inside the source. If however you plan on using this thunar action, make sure to get your own API key and replace it. The second thought I had is not to use the API directly, but try to use the normal upload form via curl so that no API key is required at all.  
**TODO:** Auto-recognize filetypes via file extension and/or `file` in order to set the proper syntax highlighting scheme for var `PB_API_FORMAT`.  
**GUI:** [Zenity dialog](https://help.gnome.org/users/zenity/stable/)  
**Requirements:** `zenity` and `curl`

#### ![Thunar Upload to Imgur](/icons/thunar-upload-to-imgur.png) [thunar-upload-to-imgur.sh](thunar-upload-to-imgur.sh)
[![Type](https://img.shields.io/badge/type-bash-red.svg)](https://en.wikipedia.org/wiki/Bash)  
This action uploads an image file to imgur and pops up a zenity-based window displaying the upload url.  
**GUI:** [Zenity dialog](https://help.gnome.org/users/zenity/stable/)  
**TODO:** Evaluate if it is possible to get rid of `gawk` requirement.
**Requirements:**  `zenity`, `gawk`, `curl`  
**Note:** Upload key is included :-)

## TODO / Ideas

* Image: convert from ... to anything via list (dropdown or radio) of target formats (jpg, png, gif, etc). Possibly also some convert options via slider or checkboxes.
* Video: encode/re-encode videos to target format (dropdown or radio for target formats). Also some ffmpeg quality options via slider, textfields and/or checkboxes
* Video to gif



## Contributions

Thanks to the following for contributing:

* [matiasw](https://github.com/matiasw)


## License

[![license](https://poser.pugx.org/cytopia/mysqldump-secure/license)](http://opensource.org/licenses/mit)

