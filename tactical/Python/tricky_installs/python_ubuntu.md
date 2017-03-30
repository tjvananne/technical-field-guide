# Setting up python in ubuntu

## installing pip

### 1) install pip

This will install pip for the python 2.x version on ubuntu

    ```
    sudo apt-get install python-pip
    ```


Then execute this to install pip for python 3.x

    ```
    sudo apt-get install python3-pip
    ```

### 2) install virtualenv

Had to add the H flag to this for it to work for some reason. The **-H** option requests that the security policy set the HOME environment variable to the home directory of the target user (root by default) as specified by the password database. (this might have been caused because I was not already in my user root directory in my terminal?)


    ```
    sudo -H pip install virtualenv
    ```

Now for python 3 (had to come back and add this step in):

    ```
    pip3 install virtualenvwrapper
    ```

*Read this at the end... This is kind of awkward, but I think I have this working with virtualenv installed for python2 (this might be shared across python versions) and virtualenvwrapper installed for python3 (once again, this might be shared across python versions). In order to test this, I'll see if I can edit the environment variable back to python2 instead of python3 and run the same `virtualenvwrapper` commands*


### 3) set environment variables

First make a directory for your virtualenvs, I'm executing this from `~$` my home dir:

    ```
    mkdir virtualenvs
    ```


There are several good examples for the difference between setting enviornment variables for current session + child processes vs setting environment variables permanently for all system processes vs setting environment variables for just your username [here](http://askubuntu.com/questions/58814/how-do-i-add-environment-variables). This [documentation](https://www.digitalocean.com/community/tutorials/how-to-read-and-set-environmental-and-shell-variables-on-a-linux-vps) from digital ocean is also pretty helpful for understanding environment variables in Linux.


I am going to proceed with the system-wide environment variable setting. Open terminal and execute:

    ```
    sudo -H gedit /etc/environment
    ```


Then type in these paths (might need to fix the `WORKON_HOME` path for your needs) then **save**!

    ```
    VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    WORKON_HOME="/home/taylor/virtualenv"
    ```

I'm doing this because I want virtualenvwrapper to default to using python3 and not python2.

**You must then log out of the account and log back in for changes to take effect**


### 4) Add virtualenvwrapper.sh execution to end of bashrc file


Execute this command to be able to edit your bashrc file (executing this from `~$` home on my user account):

    ```
    sudo gedit ~/.bashrc
    ```

Then, add this line at the very end of this file:

    ```
    . /usr/local/bin/virtualenvwrapper.sh
    ```

Close your terminal and then reopen. Now you should be able to create your virtual environment. Execute this command:

    ```
    mkvirtualenv py3564
    ```
    
Ok, so just figured out all you need to do is use the `--python=python2.7` flag to pick with python executable to make the environment with.

    ```
    mkvirtualenv --python=python2.7 py2764
    ```



    
    
Be sure to make sure that this is using the python3.5 (or whatever 3.x version you were wanting) and not the default of 2.x.



    