Git snap
========


Step by step how to create repository storage with tarsnap backup
-----------------------------------------------------------------

1. Get [Tarsnap](https://www.tarsnap.com/gettingstarted.html)
2. Create key for a gitsnap machine

  The key will be shared for all tarsnap backups on this machine.

      sudo tarsnap-keygen --keyfile /root/tarsnap.key --user YOUR_TARSNAP_USERNAME --machine MACHINE_NAME --passphrased
      sudo chmod 400 /root/tarsnap.key

  __IMPORTANT!__

  Remember given password well and make a copy of `tarsnap.key` file on some external storage (flashdisk, spare disk, another computer etc.)
  You may even delete `tarsnap.key` from gitsnap machine, it will only be used to restore and manage tarsnap backups.

3. [Create git repository storage](https://git-scm.com/book/en/v1/Git-on-the-Server-Setting-Up-the-Server):

  Assuming the storage user is `git` and the repositories will reside under the `gitsnap` directory:

      sudo mkdir -p -m 700 /home/git/gitsnap
      sudo chown git /home/git/gitsnap

4. Create write only key with no password for gitsnap

        sudo tarsnap-keymgmt --outkeyfile /home/git/.gitsnap.key -w /root/tarsnap.key
        sudo chmod 400 /home/git/.gitsnap.key
        sudo chown git /home/git/.gitsnap.key

5. Clone this repository and install gitsnap

        git clone https://github.com/royaltm/gitsnap.git .gitsnap
        sudo .gitsnap/install.sh /home/git/gitsnap

6. Creating gitsnap repository

  This will create bare repository under the `/home/git/gitsnap/your-repo-name.git`.
  The `post-receive` hook of the created repository will be set to the gitsnap's `post-receive.sh`.

      sudo -u git /home/git/gitsnap/create your-repo-name

7. You may push to the repository

  Assuming you have initialized local repository and added your ssh key to `/home/git/.ssh/authorized_keys`:

      git remote add origin git@HOST_NAME:gitsnap/your-repo-name.git
      git push -u origin master

  This will push your data to gitsnap and run post-receive hook that will
  tarsnap your repository under the name:

      git.your-repo-name.20160401-170239-320309908

  That is assuming the hook was run on 1st april 2016 at 17:02:39 and 320309908 ns.


Restoring repositories
----------------------

1. Copy your `tarsnap.key` to `/root/tarsnap.key` on the destination gitsnap machine.

2. Recreate tarsnap state directory

        sudo tarsnap --keyfile /root/tarsnap.key --fsck

3. Follow steps 3, 4, 5 from the above guide.

4. Restore

- Restore single repository

        sudo /home/git/gitsnap/restore your-repo-name

- Restore single repository from before given time

        sudo /home/git/gitsnap/restore your-repo-name 20160401-17

  The last repository from before or equal to the given time will be restored.

- Restore all repositories

        sudo /home/git/gitsnap/restore-all

- List all repositories

        sudo /home/git/gitsnap/list-all

- List all repositories' tarsnaps

        sudo /home/git/gitsnap/list-all --tarsnaps

- List single repository last tarsnap

        sudo /home/git/gitsnap/list your-repo-name

- List single repository tarsnaps

        sudo /home/git/gitsnap/list your-repo-name --all
