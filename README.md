# RangHo's Package Repository

This is my personal package repository, definitely **not** abusing GitHub Actions and Netlify.

## Active Repositories

Currently, two package repositories are complete.
They can be added to the package managers, given that the system is supported.

### Arch Linux Repository

- **Architecture**: `x86_64`

To add the Arch Linux repository, append the following lines to your `/etc/pacman.conf` file.

``` ini
[rangho-repository]
Server = https://by.rangho.dev/repository/arch
```

If `pacman` asks for the signing key, download and import the GPG public key file from [https://by.rangho.dev/repository/public.asc].
To import the key, run the following commands as root.

``` shell
curl -sSL https://by.rangho.dev/repository/public.asc > rangho-repository.asc
pacman-key --add rangho-repository.asc
pacman-key --lsign-key 5B7BDEC59930AB952EBBDEA60F0C772347B79377
```

### Void Linux Repository

- **Architecture**: `x86_64`
- **LibC**: `glibc` only

To add the Void Linux repository, create a new file in `/etc/xbps.d` named `90-repository-rangho.conf`.

``` ini
repository=https://by.rangho.dev/repository/void
```

## Work in Progress Repositories

The repositories below are currently work in progress, and may or may not be merged to the main deployment branch.

### Android Repository

As different Android applications require different commands to package the release build, each application is defined as a shell script that produce an APK file.
Currently, the build process itself works, but an F-Droid repository is yet to be created.

## How It Works

This repository makes heavy uses of reusable workflows to programmatically generate build jobs.
There are two types of workflows: (1) build workflows and (2) deploy workflows.

The build workflow will build the packages and upload them as GitHub Artifacts.
This allows manual inspection of generated packages, should things go south.

The deploy workflows will handle the deployment process to the public.

