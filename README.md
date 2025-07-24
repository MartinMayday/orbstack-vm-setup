# OrbStack VM SSH Setup

1. **On Macmax: Copy Pubkey and Open VM Console**
   ```bash
   cat ~/.ssh/id_ed25519.pub | pbcopy
   orb vm create ubuntu --name test11 --cpus 2 --memory 4
   orb vm start test11
   orb vm console test11
 	2.	In VM Console: Clone and Run
 git clone https://github.com/MartinMayday/orbstack-vm-setup.git
cd orbstack-vm-setup
bash install.sh
  	3.	On Macmax: Integrate and Test
 ~/scripts/macmax-integrate-vm.sh test11 test11 nosrcadmin ed25519 717 198.19.249.0/24
ssh test11 "echo 'Test successful'"
orb vm stop test11
orb vm delete test11 --force
 
