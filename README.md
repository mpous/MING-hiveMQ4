# MING stack for Industrial Shields PLC Raspberry Pi 4 

This is a reference architecture to run on your Industrial Shields PLC Raspberry Pi 4 with the MING stack on balena. 

## Disclaimer

This project is for educational purposes only. Do not deploy it into your premises without understanding what you are doing. USE THE SOFTWARE AT YOUR OWN RISK. THE AUTHORS AND ALL AFFILIATES ASSUME NO RESPONSIBILITY FOR YOUR SECURITY.

We strongly recommend you to have some coding and networking knowledge. Do not hesitate to read the source code and understand the mechanism of this project or contact the authors.


## Deploy the code

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/mpous/industrialshields-ming)

Follow instructions, click Add a Device and flash an SD card with that OS image dowloaded from balenaCloud. Enjoy the magic 🌟Over-The-Air🌟!

## Configure nodeRED

These variables you can set them in the balenaCloud `Device Variables` tab for the device (or globally for the whole application). If you would like to change your login credentials feel free to update these variables.

Variable Name | Value | Description | Default
------------ | ------------- | ------------- | -------------
**`USERNAME`** | `STRING` | Define a new username | `balena`
**`PASSWORD`** | `STRING` | Define a new password | `balena`
**`ENCRIPTION_KEY`** | `STRING` | Define a new key to encrypt nodeRED system | `balena`


## Install the RPIPLC node

TBD


## Troubleshooting

If you detect any issue using this block, feel free to contact us at the [forums.balena.io](https://forums.balena.io).

