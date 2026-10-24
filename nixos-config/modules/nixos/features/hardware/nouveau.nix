# Blacklist the open-source NVIDIA driver and its kernel modesetting.
{
  config,
  lib,
  ...
}: {
  options.my.hardware.nouveau.forceNomodeset = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Add `nomodeset` to the kernel command line.";
  };

  config = {
    boot.blacklistedKernelModules = ["nouveau"];
    boot.kernelParams = lib.optionals config.my.hardware.nouveau.forceNomodeset ["nomodeset"];
  };
}
