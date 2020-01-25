#!/bin/bash
#
# EnterpriseVE Backup And Restore Ceph for Proxmox VE hook script.
# Process environment variables as received from and set by eve4pve-barc.

hook() {
#    echo "EVE4PVE_BARC_PHASE:       $EVE4PVE_BARC_PHASE" 
#    echo "EVE4PVE_BARC_VMID:        $EVE4PVE_BARC_VMID" 
#    echo "EVE4PVE_BARC_PATH:        $EVE4PVE_BARC_PATH" 
#    echo "EVE4PVE_BARC_LABEL:       $EVE4PVE_BARC_LABEL" 
#    echo "EVE4PVE_BARC_KEEP:        $EVE4PVE_BARC_KEEP" 
#    echo "EVE4PVE_BARC_SNAP_NAME:   $EVE4PVE_BARC_SNAP_NAME" 
#    echo "EVE4PVE_BARC_BACKUP_FILE: $EVE4PVE_BARC_BACKUP_FILE" 
#    echo "EVE4PVE_BARC_HOST:        $EVE4PVE_BARC_HOST"
    case "$EVE4PVE_BARC_PHASE" in
        #clean job status
        clean-job-start);;
        clean-job-end);;

        #backup job status
        backup-job-start);;
        backup-job-end);;

        #create snapshot
        snap-create-pre);;
        snap-create-post);;
        snap-create-abort) ssh root@$EVE4PVE_BARC_HOST /usr/sbin/qm guest cmd $EVE4PVE_BARC_VMID fsfreeze-thaw;;

        snap-vm-pre) ssh root@$EVE4PVE_BARC_HOST /usr/sbin/qm guest cmd $EVE4PVE_BARC_VMID fsfreeze-freeze;;  
        snap-vm-post) ssh root@$EVE4PVE_BARC_HOST /usr/sbin/qm guest cmd $EVE4PVE_BARC_VMID fsfreeze-thaw;;

        #export
        export-pre);;
        export-post);;
        export-abort);;

        #export diff
        export-diff-pre);;
        export-diff-post);;
        export-diff-abort);;

        #remove snapshot
        snap-remove-pre);;
        snap-remove-post);;
        snap-remove-abort);;

        #restore job status
        restore-job-start);;
        restore-job-end);;

        #assemble job status
        assemble-job-start);;
        assemble-job-end);;

        *) echo "unknown phase '$EVE4PVE_BARC_PHASE'"; return 1;;
    esac
}

hook
