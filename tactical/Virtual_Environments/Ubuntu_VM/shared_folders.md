# Adding a shared folder (Windows host / Ubuntu VM)


## resources:

- [Old YouTube video](https://www.youtube.com/watch?v=ddExu55cJOI)
- [Stack overflow question for permission setup](http://stackoverflow.com/questions/26740113/virtualbox-shared-folder-permissions)


## Steps:

1) log into the ubuntu VM and click Devices > Insert Guest Additions CD. Follow the dialog in the terminal until the install is complete. **Restart the VM**


2) Create the directory in your windows host environment where you want the shared data to be kept. Make a note of the dir name and path.


3) In the VM, go to Devices > Shared Folders > Shared Folder Settings and click the green plus sign to add a new shared folder


4) click the drop down and navigate to the path of the dir in your windows environment, then check `Auto-mount` and `Make Permanent`. *(I like to name the folder share the same thing it is named in the windows environment to keep things simple)*


5) Now execute this bash command in the terminal:
Note: for this example, `ubuntu16_c_dev_foldershare` is the name of my shared folder I created in the Ubuntu VM and is also the name of the directory I created in the host Windows machine. The path to this directory in the Ubuntu VM is `/home/taylor/Documents/`. My username in the Ubuntu VM is `taylor`. These are all fields that you will need to replace with whatever values you need for your scenario. 

    
    sudo mount -t vboxsf ubuntu16_c_dev_foldershare /home/taylor/Documents/ubuntu16_c_dev_foldershare


6) To set up proper permissions for your user account, execute this bash command in the terminal:


    sudo adduser taylor vboxsf
    

7) Now **log out and log back in** to allow the security changes to your user account to take affect. You should now be ready to go!


**Note: Gedit doesn't like working on text files in these shared directories... You will likely receive some type of "this file is busy and can't be saved" message when trying to write to a text file with gedit**






