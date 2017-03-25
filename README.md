# Thunar Custom Actions

[![Build Status](https://travis-ci.org/cytopia/thunar-custom-actions.svg?branch=master)](https://travis-ci.org/cytopia/thunar-custom-actions)

The following actions can also be used in nautilus or any other file manager that supports custom actions.
I personally prefer thunar because of speed.


If any of the actions don't work anymore (especially the upload ones), please report here, so I can fix it.

---

**Latest added action**:

* `thunar-gpg-sign.sh`
* `thunar-gpg-verify-signature.sh`
* `thunar-video-to-gif.sh`


---

## Actions

### Multimedia

#### ![Thunar Convert to PNG](/icons/thunar-convert-to-png.png) [thunar-convert-to-png.sh](thunar-convert-to-png.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell)  ![GUI](https://img.shields.io/badge/GUI-no%20output-blue.svg)  
This action converts any image file to a png image. (Should also work with layered PSD files).  
**Requirements:** `convert`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Convert to png                 |
| Command      | thunar-convert-to-png.sh -f %f |
| File pattern | *                              |
| Appear on    | Image files                    |

#### ![Thunar Convert to JPG](/icons/thunar-convert-to-jpg.png) [thunar-convert-to-jpg.sh](thunar-convert-to-jpg.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) ![GUI](https://img.shields.io/badge/GUI-no%20output-blue.svg)  
This action converts any image file to a jpg image. (Should also work with layered PSD files).  
**Requirements:** `convert`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Convert to jpg                 |
| Command      | thunar-convert-to-jpg.sh -f %f |
| File pattern | *                              |
| Appear on    | Image files                    |

#### ![Thunar Media Info](/icons/thunar-media-info.png) [thunar-media-info.sh](thunar-media-info.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pops up a zenity-based window and displays encoding information for an audio or video file.  
**Requirements:**  `zenity` and `ffmpeg`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Media info                     |
| Command      | thunar-media-info.sh -f %f -t %n |
| File pattern | *                              |
| Appear on    | Audio files, Video files       |


#### ![Thunar Convert Video to Gif](/icons/thunar-media-info.png) [thunar-video-to-gif.sh](thunar-video-to-gif.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pops up a zenity-based window (or via `read` on the shell) asking for the final video width and creates a high quality gif from your input video.

**High quality gif:** This is achieved by doing a two-way-run. The first run creates the color palette from the video and the second run creates the gif based on that palette.

**Requirements:**  `ffmpeg`  
**Optional:**  `zenity` for gui output  
**Note:** Works for cli-only (`-c`) or via `zenity`-gui
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Video to Gif                   |
| Command      | thunar-video-to-gif.sh -f %f   |
| File pattern | *                              |
| Appear on    | Video files                    |



---

### Security

#### ![Thunar Openssl Encrypt/Decrypt](/icons/thunar-gpg-encrypt.png) [thunar-openssl-encrypt-decrypt.sh](thunar-openssl-encrypt-decrypt.sh)
[![Type](https://img.shields.io/badge/type-bash-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action will encrypt/decrypt a file based on openssl's symmetric encryption.  
**Requirements:**  `openssl` and `zenity`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Openssl Encrypt/Decrypt        |
| Command      | thunar-openssl-encrypt-decrypt.sh -f %f    |
| File pattern | *                              |
| Appear on    | Everything                     |

For detailed explanation and screenshots see this blog entry: [alan-mushi.github.io](https://alan-mushi.github.io/asap/2016/02/09/usable-openssl-symmetric-encryption.html)


#### ![Thunar GPG Encrypt](/icons/thunar-gpg-encrypt.png) [thunar-gpg-encrypt.sh](thunar-gpg-encrypt.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pops up a zenity-based window letting you choose from your gpg recipients and encrypts and signs the file with your chosen gpg key. (Asymmetric encryption).  
**Requirements:**  `gpg`, `zenity` and `pinentry-gtk-2`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | GPG Encrypt                    |
| Command      | thunar-gpg-encrypt.sh -f %f    |
| File pattern | *                              |
| Appear on    | Everything                     |


#### ![Thunar GPG Decrypt](/icons/thunar-gpg-decrypt.png) [thunar-gpg-decrypt.sh](thunar-gpg-decrypt.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) ![GUI](https://img.shields.io/badge/GUI-terminal-blue.svg)  
This action pops up a terminal window for password entry and decrypts the file with your private gpg key. (Asymmetric encryption).  
**Requirements:**  `gpg`  
**Todo:** Make gui-based password entry form.  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | GPG Decrypt                    |
| Command      | urxvtcd -e thunar-gpg-decrypt.sh -f %f |
| File pattern | *                              |
| Appear on    | Other files                    |


#### ![Thunar Sign](/icons/thunar-gpg-info.png) [thunar-gpg-sign.sh](thunar-gpg-sign.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pops up a zenity-based window, let's you choose from a list of your secret keys and creates an ascii-armored separate signature file.  
**Requirements:**  `gpg` and `zenity`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | GPG Sign                       |
| Command      | thunar-gpg-sign.sh -f %f       |
| File pattern | *                              |
| Appear on    | Other files                    |



#### ![Thunar GPG Info](/icons/thunar-gpg-info.png) [thunar-gpg-info.sh](thunar-gpg-info.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pops up a zenity-based window and displays information about the encryption of the current file. (Asymmetric encryption).  
**Requirements:**  `gpg` and `zenity`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | GPG Info                       |
| Command      | thunar-gpg-info.sh -f %f       |
| File pattern | *                              |
| Appear on    | Other files                    |


#### ![Thunar GPG Verify Signature](/icons/thunar-gpg-info.png) [thunar-gpg-verify-signature.sh](thunar-gpg-verify-signature.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pops up a zenity-based window and displays verification information about the gpg signature.  
**Requirements:**  `gpg` and `zenity`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | GPG Verify Signature           |
| Command      | thunar-gpg-verify-signature.sh.sh -f %f |
| File pattern | *                              |
| Appear on    | Other files                    |


---

### Uploads

#### ![Thunar Paste to Gist](/icons/thunar-paste-to-gist.png) [thunar-paste-to-gist.sh](thunar-paste-to-gist.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pastes a text file to gist (in private mode) and pops up a zenity-based window displaying the paste url (shortened). Additionally the paste url will also be copied to clipboard.  
**Requirements:** `zenity` and `gist`  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Paste to gist                  |
| Command      | thunar-paste-to-gist.sh -f %f  |
| File pattern | *                              |
| Appear on    | Text files                     |


#### ![Thunar Paste to Pastebin](/icons/thunar-paste-to-pastebin.png) [thunar-paste-to-pastebin.sh](thunar-paste-to-pastebin.sh)
[![Type](https://img.shields.io/badge/type-%2Fbin%2Fsh-red.svg)](https://en.wikipedia.org/?title=Bourne_shell) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action pastes a text file to pastebin and pops up a zenity-based window displaying the paste url.  
**Requirements:** `zenity` and `curl`  
**Note:** The pastebin API only allows 25 pastes per free account per every 24 hours. I have added two API keys inside the source. If however you plan on using this thunar action, make sure to get your own API key and replace it. The second thought I had is not to use the API directly, but try to use the normal upload form via curl so that no API key is required at all.  
**Todo:** Expand file type recognition to set the proper syntax highlighting scheme for var `PB_API_FORMAT`.  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Paste to pastebin              |
| Command      | thunar-paste-to-pastebin.sh -f %f  |
| File pattern | *                              |
| Appear on    | Text files                     |

#### ![Thunar Upload to Imgur](/icons/thunar-upload-to-imgur.png) [thunar-upload-to-imgur.sh](thunar-upload-to-imgur.sh)
[![Type](https://img.shields.io/badge/type-bash-red.svg)](https://en.wikipedia.org/wiki/Bash)  [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action uploads an image file to imgur and pops up a zenity-based window displaying the upload url.  
**Requirements:**  `zenity`, `gawk`, `curl`  
**Note:** Upload key is included :-)  
**Todo:** Evaluate if it is possible to get rid of `gawk` requirement.  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Upload to imgur                |
| Command      | thunar-upload-to-imgur.sh -f %f  |
| File pattern | *                              |
| Appear on    | Image files                    |




#### ![Thunar Upload to Postimage](/icons/thunar-upload-to-postimage.png) [thunar-upload-to-postimage.sh](thunar-upload-to-postimage.sh)
[![Type](https://img.shields.io/badge/type-bash-red.svg)](https://en.wikipedia.org/wiki/Bash) [![GUI](https://img.shields.io/badge/GUI-zenity-blue.svg)](https://help.gnome.org/users/zenity/stable/)  
This action uploads an image file to postimage.org and pops up a zenity-based window displaying the upload url.  
**Requirements:**  `zenity`, `gawk`, `curl`  
**Todo:** Evaluate if it is possible to get rid of `gawk` requirement.  
**Thunar settings:**  

| name         | value                          |
|--------------|--------------------------------|
| Name         | Upload to postimage            |
| Command      | thunar-upload-to-postimage.sh -f %f  |
| File pattern | *                              |
| Appear on    | Image files                    |


## General Setup

All actions require the `-f` parameter which specifies the file to work on. Prior Thunar/Nautilus integration you can test them all on the command line to make sure they do what they are supposed to do:
```bash
thunar-action.sh -f /path/to/file
```
The equivilent thunar command would be:
```bash
/path/to/thunar-action.sh -f %f
```

**Note about substitutions in Thunar**:
```bash
%f    The path to the fisrt selected file
%F    The paths to all selected files
%d    Directory containing the file that is passed in %f
%D    Directory containing the files that are passed in %F
%n    The first selected filename (without path)
%N    The selected filenames (without paths)
```


## TODO / Ideas

* Image: convert from ... to anything via list (dropdown or radio) of target formats (jpg, png, gif, etc). Possibly also some convert options via slider or checkboxes.
* Video: encode/re-encode videos to target format (dropdown or radio for target formats). Also some ffmpeg quality options via slider, textfields and/or checkboxes
* Video to gif



## Contributions

Thanks to the following for contributing:

* [matiasw](https://github.com/matiasw)
* [alan-mushi](https://github.com/alan-mushi)


## License

[![license](https://poser.pugx.org/cytopia/mysqldump-secure/license)](http://opensource.org/licenses/mit)

