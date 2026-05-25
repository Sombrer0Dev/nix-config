{
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/41e94d5b-4690-4770-adef-1ec231d050ef";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
      "exec"
    ];
  };
}
