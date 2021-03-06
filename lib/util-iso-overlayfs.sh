#!/bin/bash
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

track_fs() {
    info "%s mount: [%s]" "${iso_fs}" "$5"
    mount "$@" && FS_ACTIVE_MOUNTS=("$5" "${FS_ACTIVE_MOUNTS[@]}")
}

# $1: new branch
mount_fs_root(){
    FS_ACTIVE_MOUNTS=()
    mkdir -p "${mnt_dir}/work"
    track_fs -t overlay overlay -olowerdir="${work_dir}/rootfs",upperdir="$1",workdir="${mnt_dir}/work" "$1"
}

mount_fs_desktop(){
    FS_ACTIVE_MOUNTS=()
    mkdir -p "${mnt_dir}/work"
    track_fs -t overlay overlay -olowerdir="${work_dir}/desktopfs":"${work_dir}/rootfs",upperdir="$1",workdir="${mnt_dir}/work" "$1"
}

mount_fs_live(){
    FS_ACTIVE_MOUNTS=()
    mkdir -p "${mnt_dir}/work"
    track_fs -t overlay overlay -olowerdir="${work_dir}/livefs":"${work_dir}/desktopfs":"${work_dir}/rootfs",upperdir="$1",workdir="${mnt_dir}/work" "$1"
}

mount_fs_net(){
    FS_ACTIVE_MOUNTS=()
    mkdir -p "${mnt_dir}/work"
    track_fs -t overlay overlay -olowerdir="${work_dir}/livefs":"${work_dir}/rootfs",upperdir="$1",workdir="${mnt_dir}/work" "$1"
}

umount_fs(){
    if [[ -n ${FS_ACTIVE_MOUNTS[@]} ]];then
        info "%s umount: [%s]" "${iso_fs}" "${FS_ACTIVE_MOUNTS[@]}"
        umount "${FS_ACTIVE_MOUNTS[@]}"
        unset FS_ACTIVE_MOUNTS
        rm -rf "${mnt_dir}/work"
    fi
}
