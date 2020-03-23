# docker-ros2

## installation

1. Use raspberry pi 4 to get enough computation ability.

    (pi 3 Model B+ will crash after `ros2 launch turtlebot3_bringup robot.launch.py`, while it is the default board used by turtlebot3 waffle_pi)

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

            ```$ systemctl mask systemd-networkd-wait-online.service```
        3. Restart Raspberry Pi 4

            ```$ reboot```

    From now, you can use SSH. Refer to Connect Remote PC to SBC

4. Copy `host-installation.sh` and `docker-compose.yaml` from this respository to Raspberry Pi 4

5. Configure Raspberry Pi 4

    ```$ sudo bash /YOUR_PATH/host-installation.sh```

6. Start the container

    ```$ docker-compose up```
