#!/bin/bash
#
# EnterpriseVE Backup And Restore Ceph for Proxmox VE hook script.

# Process environment variables as received from and set by eve4pve-barc.

hook() {
    echo "EVE4PVE_BARC_PHASE:       $EVE4PVE_BARC_PHASE" 
    echo "EVE4PVE_BARC_VMID:        $EVE4PVE_BARC_VMID" 
    echo "EVE4PVE_BARC_PATH:        $EVE4PVE_BARC_PATH" 
    echo "EVE4PVE_BARC_LABEL:       $EVE4PVE_BARC_LABEL" 
    echo "EVE4PVE_BARC_KEEP:        $EVE4PVE_BARC_KEEP" 
    echo "EVE4PVE_BARC_SNAP_NAME:   $EVE4PVE_BARC_SNAP_NAME" 
    echo "EVE4PVE_BARC_BACKUP_FILE: $EVE4PVE_BARC_BACKUP_FILE" 

    case "$EVE4PVE_BARC_PHASE" in
        #clean job status
        clean-job-start);;
        clean-job-end);;

        #backup job status
        backup-job-start);;
        backup-job-end);;
        backup-job-abort);;

        #create snapshot
        snap-create-pre);;
        snap-create-post);;
        snap-create-abort);;

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
        snap-remove-aboort);;

        *) echo "unknown phase '$phase'"; return 1;;
    esac
}

hook