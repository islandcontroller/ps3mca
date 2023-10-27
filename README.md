# ps3mca

[![License](https://img.shields.io/github/license/islandcontroller/ps3mca)](LICENSE) [![GitHub](https://shields.io/badge/github-islandcontroller%2Fps3mca-black?logo=github)](https://github.com/islandcontroller/ps3mca) [![Docker Hub](https://shields.io/badge/docker-islandc%2Fps3mca-blue?logo=docker)](https://hub.docker.com/r/islandc/ps3mca) ![Docker Image Version (latest semver)](https://img.shields.io/docker/v/islandc/ps3mca?sort=semver)

*A simple docker container for use with the PS3MCA (PlayStation 3 Memory Card Adaptor) tool.*


## System Requirements

* Linux Host or WSL2 with [usbipd](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)
* Docker Engine
* PlayStation 3 Memory Card Adaptor (CECHZM1)

## Usage

1. *(WSL only)* Attach the Memory Card Adaptor to your WSL2 instance

        usbipd wsl list
        usbipd wsl attach --busid <...>

  (Requires elevated privileges on first run)

2. Launch container. Requires volume-mounting `/dev/bus/usb/`.

        sudo docker run --privileged -v /dev/bus/usb/:/dev/bus/usb/ --rm -it islandc/ps3mca

3. Use the tool inside the container

        ps3mca-tool -i

### Notes:
* Use a second volume mount if you want to exchange files between your hose and the container. The default workdir location is `/root/mca`.

        sudo docker run \
            --privileged \
            -v /dev/bus/usb/:/dev/bus/usb/ \
            -v $(pwd):/root/mca \
            --rm -it islandc/ps3mca

## Licensing

Unless stated otherwise, the contents of this project are licensed under the MIT License. The full license text is provided in the [`LICENSE`](LICENSE) file.

    SPDX-License-Identifier: MIT