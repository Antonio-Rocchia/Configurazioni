# Linux filesystem hierarchy
`$ man 7 file-hierarchy`

- /etc/
System-specific configuration. This directory may or may not be read-only. Frequently, this directory is pre-populated with vendor-supplied configuration files, but applications should not make assumptions about this directory being fully populated or populated at all, and should fall back to defaults if configuration is missing.

- /tmp/
The place for small temporary files. This directory is usually mounted as a "tmpfs" instance, and should hence not be used for larger files. (Use /var/tmp/ for larger files.) This directory is usually flushed at boot-up. Also, files that are not accessed within a certain time may be automatically deleted.
If applications find the environment variable $TMPDIR set, they should use the directory specified in it instead of /tmp/ (see environ(7) and IEEE Std 1003.1[4] for details).
Since /tmp/ is accessible to other users of the system, it is essential that files and subdirectories under this directory are only created with mkstemp(3), mkdtemp(3), and similar calls. For more details, see Using /tmp/ and /var/tmp/ Safely[5].

- /usr/
Vendor-supplied operating system resources. Usually read-only, but this is not required. Possibly shared between multiple hosts. This directory should not be modified by the administrator, except when installing or removing vendor-supplied packages.

- /usr/bin/
Binaries and executables for user commands that shall appear in the $PATH search path. It is recommended not to place binaries in this directory that are not useful for invocation from a shell (such as daemon binaries); these should be placed in a subdirectory of /usr/lib/ instead.

- /usr/share/
Resources shared between multiple packages, such as documentation, man pages, time zone information, fonts and other resources. Usually, the precise location and format of files stored below this directory is subject to specifications that ensure interoperability.
Note that resources placed in this directory typically are under shared ownership, i.e. multiple different packages have provide and consume these resources, on equal footing, without any obvious primary owner. This makes makes things systematically different from /usr/lib/, where ownership is generally not shared.

- /var/lib/
Persistent system data. System components may place private data in this directory.

- ~/.cache/
Persistent user cache data. User programs may place non-essential data in this directory. Flushing this directory should have no effect on operation of programs, except for increased runtimes necessary to rebuild these caches. If an application finds $XDG_CACHE_HOME set, it should use the directory specified in it instead of this directory.

- ~/.config/
Application configuration. When a new user is created, this directory will be empty or not exist at all. Applications should fall back to defaults should their configuration in this directory be missing. If an application finds $XDG_CONFIG_HOME set, it should use the directory specified in it instead of this directory.

- ~/.local/bin/
Executables that shall appear in the user's $PATH search path. It is recommended not to place executables in this directory that are not useful for invocation from a shell; these should be placed in a subdirectory of ~/.local/lib/ instead. Care should be taken when placing architecture-dependent binaries in this place, which might be problematic if the home directory is shared between multiple hosts with different architectures.

- ~/.local/lib/
Static, private vendor data that is compatible with all architectures.

- ~/.local/share/
Resources shared between multiple packages, such as fonts or artwork. Usually, the precise location and format of files stored below this directory is subject to specifications that ensure interoperability. If an application finds $XDG_DATA_HOME set, it should use the directory specified in it instead of this directory.

- ~/.local/state/
Application state. When a new user is created, this directory will be empty or not exist at all. Applications should fall back to defaults should their state in this directory be missing. If an application finds $XDG_STATE_HOME set, it should use the directory specified in it instead of this directory.

## XDG User directories
[archiwiki: XDG User directories](https://wiki.archlinux.org/title/XDG_user_directories)

xdg-user-dirs is a tool to help manage "well known" user directories like the desktop folder and the music folder. It also handles localization (i.e. translation) of the filenames.

The way it works is that xdg-user-dirs-update(1) is run very early in the login phase. This program reads a configuration file, and a set of default directories. It then creates localized versions of these directories in the users home directory and sets up a configuration file in $XDG_CONFIG_HOME/user-dirs.dirs (XDG_CONFIG_HOME defaults to ~/.config) that applications can read to find these directories.

`$ xdg-user-dirs-update`
To force the creation of English-named directories, `LC_ALL=C.UTF-8 xdg-user-dirs-update --force` can be used.

## XDG Base directory specification
[XDG base directory spefication](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

The XDG Base Directory Specification is based on the following concepts:

- There is a single base directory relative to which user-specific data files should be written. This directory is defined by the environment variable $XDG_DATA_HOME.

- There is a single base directory relative to which user-specific configuration files should be written. This directory is defined by the environment variable $XDG_CONFIG_HOME.

- There is a single base directory relative to which user-specific state data should be written. This directory is defined by the environment variable $XDG_STATE_HOME.

- There is a single base directory relative to which user-specific executable files may be written.

- There is a set of preference ordered base directories relative to which data files should be searched. This set of directories is defined by the environment variable $XDG_DATA_DIRS.

- There is a set of preference ordered base directories relative to which configuration files should be searched. This set of directories is defined by the environment variable $XDG_CONFIG_DIRS.

- There is a single base directory relative to which user-specific non-essential (cached) data should be written. This directory is defined by the environment variable $XDG_CACHE_HOME. 

[archwiki: XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory)

User directories:

- XDG_CONFIG_HOME
  - Where user-specific configurations should be written (analogous to /etc).
  - Should default to $HOME/.config.

- XDG_CACHE_HOME
  - Where user-specific non-essential (cached) data should be written (analogous to /var/cache).
  - Should default to $HOME/.cache.

- XDG_DATA_HOME
  - Where user-specific data files should be written (analogous to /usr/share).
  - Should default to $HOME/.local/share.

- XDG_STATE_HOME
  - Where user-specific state files should be written (analogous to /var/lib).
  - Should default to $HOME/.local/state.
