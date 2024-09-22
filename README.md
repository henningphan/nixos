# ISSUES
## home-manager init could not find suitable profile directory
When running `home-manage init` it might fail with could not find suitable profile directory...
Solution: Running `nix-env -q` seems to create the missing profile directory
