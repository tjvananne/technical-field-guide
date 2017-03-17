
# Installing Python Modules from Wheels


A Python wheel is essentially a precompiled binary file that is super easy to install. This is only necessary if you had issues installing the module with "pip install (name of package here)" classic method. 

I usually resort to this whenever I get one of those unbelievably frustrating "egg error code 1" or "error in easy_setup.py" errors on a normal pip install.


## where to get wheels

There are two major places I go to look for python wheel files:
- [python wheels](pythonwheels.com)
- Christoph Gohlke's ["Unofficial Windows Binaries for Python Extension Packages"](http://www.lfd.uci.edu/~gohlke/pythonlibs/)
    - It's probably about time this became "official" with how many pieces of documentation refer back to this person's website, keep up the good work Christoph, you're awesome


It is really important to know both which version of python you're using as well as whether it is 64 or 32 bit. I like to give my python virtual environments a naming convention that corresponds to their version and bit-version. For example, I'm currently in my `py3464` virtual environment which is python 3.4 64-bit version.


Also, if you're using a virtual environment, make sure you activate it before getting started
    
    activate py3464
    

I messed up my paths for virtual environments, so I have to cd into the `py3464/Scripts` directory, then run `activate` in the command prompt in order to activate my virtual environment. That is probably an easy fix but I haven't got around to it yet and the workaround takes two seconds. (Plus I've added enough junk to my %PATH% variable that I think I'm fine with this workaround).



## Installing the wheel

Now once your virtual environment is activated (if you're just using the non-virtualenv version of python, forget about that last part), cd into
your "downloads" directory, or wherever you have the freshly downloaded wheel file.


Next, execute: 

    pip install (name of wheel here.whl)
    
Don't forget the `.whl` extension, or better yet just copy pasta.

    

