Fresh install python 3.4 64 bit version
- During install, click "yes" for adding to path

Fresh install python 2.7 64 bit version
- During install, keep "no" checked to not add to path

test that executing "python" starts python version 3.4

exit python

execute:

	python -m pip install --upgrade pip

then:
	python -m pip install virtualenv


then: 
	python -m pip install virtualenvwrapper-win

then:

	mkvirtualenv py3464

Go to wherever you specified your WORKON_HOME path to be and make sure it actually created your virtual environment.

In the same command prompt window, test out your `deactivate`, `workon py3464` commands to make sure you're able to activate and deactivate your environment

### setting up a virtual env for python 2.7

Now go back to environment variables and add these two to your path manually:

	C:/Python27
	C:/Python27/Scripts

Then move them **above/before the corresponding python 3.4 paths** that are already in your PATH variable.

**CLOSE AND REOPEN** your command prompt if you didn't close it yet. 

Type in `python` and make sure you get the 2.7 version REPL and not the 3.4 version.


execute:

	python -m pip install --upgrade pip

then:

	python -m pip install virtualenv


You might get a warning there that it is already installed?
that confused me... Not sure how that happened to be honest..


then: 

	python -m pip install virtualenvwrapper-win

then:

	mkvirtualenv py2764

Now, just like last time, go to wherever your WORKON_HOME path is pointing and make sure that the py2764 directory / environment was created.

Not test our your `deactivate` and `workon py2764` commands to make sure those are both working.

Test those same commands for you py3464 environment as well to make sure they are both working.

And now you're good to go! Just make sure you have the correct one activated whenever you're doing work.

*Note that calling `python -m ...` will refer to the correct version of python that corresponds to whichever virtualenv you have activated*

*also note, it is advisable for some reason to use the `python -m pip install [package name here]` version of the pip install command when on windows. I'm not asking questions here, just doing it, because it works better and is cleaner.*

## using IPython (jupyter) notebook inside virtualenv

*Note that this guide assumes you already also have virtualenvwrapper or virtualenvwrapper-win set up (like we just did)*

using this guide [here](http://help.pythonanywhere.com/pages/IPythonNotebookVirtualenvs)

*for the instructions below, my virtual env is called `py3464` so replace your virtual env name with wherever you see that*


0) activate your virtualenv and install jupyter

	workon py3464
	python -m pip install jupyter

1) install the ipython kernel module into your virtualenv

	python -m pip install ipykernel

2) run the kernel "self-install" script:

	python -m ipykernel install --user --name=py3464







