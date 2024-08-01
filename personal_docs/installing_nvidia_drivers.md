# Installing nvidia drivers

## Fedora
If using secure boot you need to enroll the certificates for the driver first.

> [!NOTE] Before installing the drivers
> ```sh
> $ cat /usr/share/doc/akmods/README.secureboot # Follow instructions
> # FOLLOW THE INSTRUCTION IN THE README
> ```

Then [follow this guide](https://rpmfusion.org/Howto/NVIDIA#Determining_your_card_model)

> [!NOTE]
> If you already installed the drivers you need to enroll the certificates and the rebuild the drivers
> [source](https://discussion.fedoraproject.org/t/nvidia-kernel-module-missing-falling-back-to-nouveau-in-fedora39/99171/2)
> ```sh
> $ cat /usr/share/doc/akmods/README.secureboot # Follow instructions
> # FOLLOW THE INSTRUCTION IN THE README
> $ sudo dnf remove kmod-nvidia-$(uname -r)
> $ sudo akmods --force
> ```
> Reboot
> The nvidia modules should now properly load and function.

Run `$ nvidia-smi` to check if the drivers are loaded correclty

