# OrbStack VM SSH Setup

This repo provides a simple script (install.sh) to add your macmax SSH key to a new OrbStack Ubuntu VM. The workflow is minimal: Create/start VM, run in console, integrate on macmax.

**Prerequisites:**
- OrbStack on macmax.
- SSH key on macmax (~/.ssh/id_ed25519) with no passphrase or in Keychain.
- VM is Ubuntu-based with SSH enabled.

1. **On Macmax: Copy Pubkey and Create/Start/Open VM Console**
   ```bash
   cat ~/.ssh/id_ed25519.pub | pbcopy  # Copy pubkey to clipboard

   # Create VM (adjust specs)
   orb vm create ubuntu --name test11 --cpus 2 --memory 4

   # Start VM
   orb vm start test11

   # Open console
   orb vm console test11
   ```

2. **In VM Console: Clone Repo and Run install.sh (Paste Pubkey When Prompted)**
   ```bash
   git clone https://github.com/MartinMayday/orbstack-vm-setup.git
   cd orbstack-vm-setup
   bash install.sh  # Paste pubkey from clipboard when prompted
   ```

3. **On Macmax: Run Integration Script (Tests, Adds to Config/Known Hosts/Hosts, Updates IP if Needed)**
   ```bash
   ~/scripts/macmax-integrate-vm.sh test11 test11 nosrcadmin ed25519 717 198.19.249.0/24

   # Final test
   ssh test11 "echo Test successful"
   ```
