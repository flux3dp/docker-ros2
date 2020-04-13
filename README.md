# docker-ros2

## Description

Setup a turtlebot3 with ros2 in a clean raspberry pi SD card.
Include a docker container with docker network mode "host"

## Prerequisite

It is better if you have a private docker registry to pull from pre-build image. Currently `192.168.16.205:5000`. If you want to add yours, modify `host-installation.sh` and `docker-compose.yaml`, or simply build docker image locally.

## installation

1. Setup a turtlebot3 hardware with raspberry pi 4

    (pi 3 Model B+ will crash after `ros2 launch turtlebot3_bringup robot.launch.py`, while it is the default board used by turtlebot3 waffle_pi. [issue #546](https://github.com/ROBOTIS-GIT/turtlebot3/issues/546#issuecomment-610725769))

2. Start from a clean OS image. Use [BalenaEther](https://www.balena.io/etcher/) to Flash [Raspberry Pi 3 (64-bit ARM) preinstalled server image](http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/) to SD card

3. Setup WiFi
    1. Create config file and start to edit.

        `$ sudo touch /etc/netplan/01-netcfg.yaml`

        `$ sudo nano /etc/netplan/01-netcfg.yaml`
    2. Write following content into `/etc/netplan/01-netcfg.yaml`:

        ```yaml
        network:
            version: 2
            renderer: networkd
            ethernets:
                eth0:
                    dhcp4: yes
                    dhcp6: yes
                    optional: true
            wifis:
                wlan0:
                    dhcp4: yes
                    dhcp6: yes
                    access-points:
                        "YOUR_WIFI_NAME":
                            password: "YOUR_WIFI_PASSWORD"
        ```

        WiFi `FLUX 2.4` is preffered, while `FLUX-2F-HINET2.4G` is not stable and frequently disconnected

        Note that **raspberry pi 4 WiFi doesn't support 5G** (while the official document says it support 🙄)

    3. Apply all configuration for the renderers, and then restart Raspberry Pi 4.

        1. Apply all configuration for the renderers

            ```$ sudo netplan apply```
        2. Set the systemd to prevent boot-up delay even if there is no network at startup.

            ```$ sudo systemctl mask systemd-networkd-wait-online.service```
        3. Restart Raspberry Pi 4

            ```$ reboot```

    From now, you can use SSH. Refer to Connect Remote PC to SBC

4. Copy `host-installation.sh` and `docker-compose.yaml` from this respository to Raspberry Pi 4. (If you don't want to pull image from your private docker registry, please copy `Dockerfile` and `entrypoint.sh` and edit `docker-compose.yaml` to build locally)

5. Configure Raspberry Pi 4, setup OpenCR rule and install docker

    ```$ sudo bash /YOUR_PATH/host-installation.sh```

6. Start the service

    ```$ docker-compose up```

## Trouble Shooting

### Fail when running host-installation.sh

If you encounter

```shell
crash E: Could not get lock /var/lib/dpkg/lock – open (11: Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?
```

There are probably a daily system updating your package. You can check by `ps aux | grep -i apt`.

If there is the daily update, just wait for it complete, and do the remaining task in installation.sh
