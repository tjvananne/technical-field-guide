
# Multiple Python Versions on Windows with virtualenvwrapper-win

## 1) Download and install

For example, I want to be able to run python 3.4 and python 2.7 on my machine. 
These instructions should work for whatever combination of Python versions 
you want to install. (It can be more than just 2 if you want).

For this example, we will consider python 3.4 to be our "primary" version
and 2.7 to be the "secondary" version. 


1) Fresh download and install python 3.4 64 bit version
	- During install, **click "yes" for adding to path**

2) Fresh install python 2.7 64 bit version
	- During install, **click "no" checked to not add to path** (we'll add it later manually)

3) Now open a command prompt and execute:

	python
	
It should put you in python 3.4

4) exit python with `ctrl-Z` then pressing `ENTER` key

## 2) Upgrade pip

1) execute:

	python -m pip install --upgrade pip


## 3) Set a "WORKON_HOME" system environment variable	

1) Click start button and search "system environment variables" -- you should see
something similar to "edit system environment variables", click that.

2) On "advanced" tab, click "Enviornment Variables" button, then in the bottom half, click the "New..." button.

3) Name the variable "WORKON_HOME" and make the value the file path to where you want all
of your virtual environments to be located (mine is `C:/venvs`) 


## 4) Install virtualenv and virtualenvwrapper-win

Close any command prompts you have open and then open a new command prompt and execute these commands:

	python -m pip install virtualenv
	python -m pip install virtualenvwrapper-win

	
## 5) Create a virtual env for this python version	

In a command prompt execute the `mkvirtualenv` command followed by what you want to name your 
virtual environment. I like to use the naming convention 'py' + '2 digit 
version number' + bit version (64 or 32):

	mkvirtualenv py3464

Go to wherever you specified your WORKON_HOME path to be and make sure it actually created your virtual environment.

In the same command prompt window, test out your `deactivate`, `workon py3464` commands to make sure you're able to toggle between activating and deactivating your environment


## Minor Simplification to Mention here:

**Instead of messing around too much with the order your Python installations show up in your path environment variable, you can just pass in which version of
Python you want to use when creating your virtual environment like so:**

    mkvirtualenv --python C:/Python34/python.exe mypython34env
	
**I checked this by first running mkvirtualenv without any "--python" flag, and it defaulted to Python35, but I was successfully able to create a virtual env
with the Python34 interpreter using the method above. So anywhere in this document where I mention the shifting of values in the path environment variable, it
is safe to assume that you can use this method above instead.**



## 6) Set up Paths for secondary Python version

Now go back to environment variables and add these two to your path manually (I'm adding `Python27` because that is the secondary version I would like to
install, replace that with whatever version you're wanting to be your secondary):

* These are what I'm adding 
	- C:/Python27
	- C:/Python27/Scripts

Then move them **above/before the corresponding python 3.4 paths** that are already in your PATH variable.
(I know, this kinda sucks, but its only for the setup process initially!)

**CLOSE AND REOPEN** your command prompt if you didn't close it yet. 

Type in `python` and make sure you get the 2.7 (secondary) version REPL and not the 3.4 (primary) version.

## 7) Upgrade pip for secondary python version

execute:

	python -m pip install --upgrade pip

## 8) Install virtualenv and virtualenvwrapper-win
	
then execute these commands:

	python -m pip install virtualenv
	python -m pip install virtualenvwrapper-win
	mkvirtualenv py2764

	
* Now, just like last time, go to wherever your WORKON_HOME path is pointing and make sure that the py2764 directory / environment was created.
* Now test our your `deactivate` and `workon py2764` commands to make sure those are both working.
* Make sure you're able to switch back and forth between your primary and secondary versions in the same command prompt.
* And now you're good to go! Just make sure you have the correct one activated whenever you're doing work.

*Note that calling `python -m ...` will refer to the correct version of python that corresponds to whichever virtualenv you have activated*

*also note, it is advisable for some reason to use the `python -m pip install [package name here]` version of the pip install command when on windows. 
I'm not asking questions here, just doing it, because it works better and is cleaner.*

## 9) using IPython (jupyter) notebook inside virtualenv

*Note that this guide assumes you already also have virtualenvwrapper or virtualenvwrapper-win set up (like we just did)*

using this guide [here](http://help.pythonanywhere.com/pages/IPythonNotebookVirtualenvs)

*for the instructions below, my virtual env is called `py3464` so replace your virtual env name with wherever you see that*


**1) activate your virtualenv and install jupyter**

    
    workon py3464
	python -m pip install jupyter
    
	
**2) install the ipython kernel module into your virtualenv**


    python -m pip install ipykernel

	
**3) run the kernel "self-install" script:**


    python -m ipykernel install --user --name=py3464

	
## Log of Errors I received while setting this up:


**Microsoft Visual C++ 9.0 is required.**
- received on 3/19/2017
- while installing jupyter in my python 2.7 (py2764) virtual environment
- Full python installer verison name was python-2.7.11amd64.msi
- Running in Windows 10
- Python error message says to go to this [site](http://aka.ms/vcpython27) and download Microsoft Visual C++ 9.0 for Python 2.7
	- **Installing C++ compiler for Python 2.7 from the site above worked**
- When installing **Python 3.5.3** I had to open a command prompt as administrator, cd into downloads folder and execute: `python-3.5.3-amd64.exe TargetDir=c:\Python35` and then it worked


	






