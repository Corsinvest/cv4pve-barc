# eve4pve-barc

[![Join the chat at https://gitter.im/eve4pve-barc/Lobby](https://badges.gitter.im/eve4pve-barc/Lobby.svg)](https://gitter.im/eve4pve-barc/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Backup And Restore Ceph for Proxmox VE

[More information about eve4pve-barc](http://www.enterpriseve.com/backup-and-restore-ceph-proxmox-ve/)

Ceph Documentation

[Incremental snapshots with rbd](http://ceph.com/dev-notes/incremental-snapshots-with-rbd/)

[rdb – manage rados block device (rbd) images](http://docs.ceph.com/docs/master/man/8/rbd/)
```
    ______      __                       _              _    ________
   / ____/___  / /____  _________  _____(_)_______     | |  / / ____/
  / __/ / __ \/ __/ _ \/ ___/ __ \/ ___/ / ___/ _ \    | | / / __/
 / /___/ / / / /_/  __/ /  / /_/ / /  / (__  )  __/    | |/ / /___
/_____/_/ /_/\__/\___/_/  / .___/_/  /_/____/\___/     |___/_____/
                         /_/

EnterpriseVE Backup And Restore Ceph for Proxmox VE  (Made in Italy)

Usage:
    eve4pve-barc <COMMAND> [ARGS] [OPTIONS]
    eve4pve-barc help
    eve4pve-barc version
 
    eve4pve-barc create  --vmid=<string> --label=<string> --path=<string> --keep=<integer>
                         --script=<string> --unprotect-snap --syslog
    eve4pve-barc destroy --vmid=<string> --label=<string> --path=<string> 
    eve4pve-barc enable  --vmid=<string> --label=<string> --path=<string> 
    eve4pve-barc disable --vmid=<string> --label=<string> --path=<string> 

    eve4pve-barc backup  --vmid=<string> --label=<string> --path=<string> --keep=<integer>
                         --script=<string> --unprotect-snap --syslog 
    eve4pve-barc restore --vmid=<string> --label=<string> --path=<string>
                         --script=<string> --syslog 

    eve4pve-barc status  --vmid=<string> --label=<string> --path=<string>   
    eve4pve-barc clean   --vmid=<string> --label=<string> --path=<string> --keep=<integer>
    eve4pve-barc reset   --vmid=<string> --label=<string> 

Commands:
    version              Show version program.
    help                 Show help program.
    create               Create backup job from scheduler.
    destroy              Remove backup job from scheduler.
    enable               Enable backup job from scheduler.
    disable              Disable backup job from scheduler.
    status               Get list of all backups.
    clean                Clear all backup.
    reset                Remove all snapshots on images specific vm in Ceph.
    backup               Will backup one time.
    restore              Will restore one time.

Options:
    --vmid=              The ID of the VM, comma separated (es. 100,101,102), 
                         'all-???' for all known guest systems in specific host (es. all-pve1, all-$(hostname)),
                         'all' for all known guest systems in cluster.
    --label=             Is usually 'hourly', 'daily', 'weekly', or 'monthly'.
    --path=              Path destination backup.
    --keep=              Specify the number of backup which should will keep, Default 1.
    --script=            Use specified hook script.
                         Es. /usr/share/doc/eve4pve-barc/examples/script-hook.sh
    --syslog             Write messages into the system log.
    --unprotect-snap     Disable protection snapshot, default is protected. 
                         In Proxmox VE 'protected snapshot' cause problem in remove VM/CT see documentation.

Report bugs to <support@enterpriseve.com>. 
```

# Introduction
Backup And Restore Ceph for Proxmox VE with retention.
This solution implement backup for Ceph cluster exporting to specific directory.
The mechanism using Ceph snapshot, export and export differential.
In backup export image and config file VM/CT.

For *continuous data protection* see [eve4pve-autosnap](https://github.com/EnterpriseVE/eve4pve-autosnap)

# Main features
* For KVM and LXC
* Can keep multiple backup
* Syslog integration
* Multiple schedule VM using --label (es. daily,monthly)
* Hook script
* Multiple VM single execution
* Copy config and firewall files
* Export any vm in cluster 'all'
* Export any vm in specific host 'all-hostname' 
* Show size of backup and incremental
* Check 'No backup' flag in disk configuration
* Protected/unprotected snap mode

# Protected / unprotected snapshot
During backup snapshot is created in protected mode, to avoid accidental deletion.
In Proxom VE remove VM not possible with error "Removing all snapshots: 0% complete...failed".
The problem is **Proxmox VE unprotect only the snapshos it knows**.

Whit parameter **--unprotect-snap** is possible to disable protection snap.

# Configuration and use
Download package eve4pve-barc_?.?.?-?_all.deb, on your Proxmox VE host and install:
```
wget https://github.com/EnterpriseVE/eve4pve-barc/releases/latest
dpkg -i eve4pve-barc_?.?.?-?_all.deb
```
This tool need basically no configuration.

## Backup a VM one time
```
root@pve1:~# eve4pve-barc backup --vmid=111 --label='daily' --path=/mnt/bckceph --keep=2
```
This command backup VM 111. The --keep tells that it should be kept 2 backup, if there are more than 2 backup, the 3 one will be erased (sorted by creation time).
## Create a recurring backup job
```
root@pve1:~# eve4pve-barc create --vmid=111 --label='daily' --path=/mnt/bckceph --keep=5
```

## Delete a recurring backup job
```
root@pve1:~# eve4pve-barc destroy --vmid=111 --label='daily' --path=/mnt/bckceph --keep=5
```

## Pause a backup job
```
root@pve1:~# eve4pve-barc disable --vmid=111 --label='daily'
```

## Reactivate a backup job
```
root@pve1:~# eve4pve-barc enable --vmid=111 --label='daily'
```

## Status
Show status backup in directory destination.

```
root@pve1:~# eve4pve-barc status --vmid=111,112 --label='daily' --path=/mnt/bckceph

VM  TYPE SIZE   BACKUP            IMAGE
111 img    4.8G 17-02-08 11:08:21 pool-rbd.vm-111-disk-1
111 diff   9.3M 17-02-08 17:22:54 pool-rbd.vm-111-disk-1
111 diff   4.5K 17-02-08 17:26:42 pool-rbd.vm-111-disk-1
111 diff   4.5K 17-02-08 17:27:33 pool-rbd.vm-111-disk-1
111 img     512 17-02-08 11:08:21 pool-rbd.vm-111-disk-2
111 diff   4.5K 17-02-08 17:22:54 pool-rbd.vm-111-disk-2
111 diff   4.5K 17-02-08 17:26:42 pool-rbd.vm-111-disk-2
111 diff   4.5K 17-02-08 17:27:33 pool-rbd.vm-111-disk-2
111 img     512 17-02-08 11:08:21 pool-rbd.vm-111-disk-3
111 diff   4.5K 17-02-08 17:22:54 pool-rbd.vm-111-disk-3
111 diff   4.5K 17-02-08 17:26:42 pool-rbd.vm-111-disk-3
111 diff   4.5K 17-02-08 17:27:33 pool-rbd.vm-111-disk-3
112 img     10G 17-02-08 17:22:54 pool-rbd.vm-112-disk-1
112 diff   7.4M 17-02-08 17:26:42 pool-rbd.vm-112-disk-1
112 diff   1.9M 17-02-08 17:27:33 pool-rbd.vm-112-disk-1

```

## Restore a VM one time
```
root@pve1:~# eve4pve-barc restore --vmid=111 --label='daily' --path=/mnt/bckceph
```
This command restore single image.

### Select image restore
![alt text](./docs/select-image.png "Select image restore")

### Select time restore
![alt text](./docs/select-time.png "Select time restore")

### Select pool destination
![alt text](./docs/select-pool.png "Select pool destination")

### Input name image destination
![alt text](./docs/name-image-destination.png "Input name image destination")

### Confirm restore
![alt text](./docs/confirm-restore.png "Confirm restore")

### Process output restore
```
Start restore process
Inital import 170108013045.pool-rbd.vm-111-disk-1.img
Importing image: 100% complete...done.
Differential /mnt/bckceph/barc/111/daily/170110112247.pool-rbd.vm-111-disk-1.diff
Importing image diff: 100% complete...done.
Differential /mnt/bckceph/barc/111/daily/170110113110.pool-rbd.vm-111-disk-1.diff
Importing image diff: 100% complete...done.
Differential /mnt/bckceph/barc/111/daily/170110113204.pool-rbd.vm-111-disk-1.diff
Importing image diff: 100% complete...done.
Differential /mnt/bckceph/barc/111/daily/170110114616.pool-rbd.vm-111-disk-1.diff
Importing image diff: 100% complete...done.
Differential /mnt/bckceph/barc/111/daily/170110114730.pool-rbd.vm-111-disk-1.diff
Importing image diff: 100% complete...done.
Removing all snapshots: 100% complete...done.
Backup pool-rbd.vm-111-disk-1 restored in pool-rbd/vm-111-disk-1-restored with success!
Consider to manually create VM/CT and change config file from backup adapting restored image.
```

## Changing parameters
You can edit the configuration in /etc/cron.d/eve4pve-barc or destroy the job and create it new.