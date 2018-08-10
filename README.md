# Build-Kino

## Purpose
* TODO : describe the purpose of the `build-kino` repository
  * Kino main app
  * Catalog module
  * Project module


## Installation
Install Kino on your computer
1. clone the `kino-build` repository in the folder of your choice
2. move inside the created `kino-build` folder
3. clone the `kino` repository
4. modify `vagrant_up.bat` and `vagrant_halt.bat`:
   * set the working folder to the current folder
   * example: `D:\Dev\kino-build`
5. run `vagrant_up.bat` (by double-clic or commandline)
   The first execution takes a lot of time because of following tasks:
   * creation and startup of the Ubuntu virtual machine
   * creation (and backup as tar.gz) of the docker images of the Kino stack
   * startup of the docker containers


## Configuration
Initialize Kino models with default data
1. connect to the virtual machine
   * `ssh vagrant@127.0.0.1:2222`
2. initialize database with default data
   ```
   docker exec -ti vagrant_app_1 python manage.py loaddata kit_full.yaml
   ```
   You can create your own data kits and load them via the same command.


## Usage
Kino usage is documented in its own repository: https://github.com/rlichiere/kino
 

## Troubleshooting

### Usefull commands

#### Relaunch app-start.sh
This command can be usefull if you want to reexecute app-start.sh
```
docker exec -ti vagrant_app_1 sh app-start.sh -e ADMIN_USER admin -e ADMIN_EMAIL admin@domain.tld -e ADMIN_PASSWORD manager
```

#### Load a specific dataset to database
Import models data from yourdataset.yaml in database
```
docker exec -ti vagrant_app_1 python manage.py loaddata yourdataset.yaml
```

#### Restart kino containers
* Restart only the main container and attach to its logs
  ```
  sh restart.sh
  ```
* Restart all containers
  ```
  sh restart.sh all -d
  ```

#### Show docker stats
* Monitor main container stats
  ```
  sh stats.sh
  ```
* Show all containers stats
  ```
  sh stats.sh all -d
  ```
