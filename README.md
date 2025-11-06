# Patient-Management-Database
Some of the libraries used in my project are exclusive to Virtual Pascal. Hence, although outdated, Virtual Pascal provides the functionality needed to complete this project.

First, copy this URL into your browser to download the Pascal compiler:

https://www.freepascal.org/download.html

Follow the link that corresponds to your operating system, download the compatible version, and run the installer to complete the installation.

Once the compiler has been downloaded, copy and paste this URL into your browser to download the Pascal IDE:

https://www.softpedia.com/get/Programming/Coding-languages-Compilers/Virtual-Pascal.shtml

After the download is complete, extract the files. Open the extracted folder and locate the application named “setupw32” (Windows), or the equivalent for your operating system. Run it, allowing it to make changes when necessary.

Read and accept the license agreement, then press ALT + R, followed by Enter, to install the IDE.

After installing, head to your directory and navigate to the "vp21" folder. Inside, open "bin.w32", then scroll until you reach the "vp" application. Right-click "vp" and let it run as administrator, allowing it to make changes when necessary.

Press Enter until the message disappears. You will see the File menu at the top left of the screen. Use the left and right arrow keys to navigate through the menu. Once you have selected File, press Enter, then press the down arrow to select New. (To return to the top menu bar at any time, press F10.) 

Once you have selected New, copy the InitialProgram code from the repository. To paste the code in the IDE, click inside the editor window and press Shift+Insert. (Repeat this process for MainProgram.) 

It should be noted that the program works for specific paths within folders. Therefore, you should create a new folder in File Explorer where you would like the files to be stored. After creating the folder, open the InitialProgram and MainProgram files, and locate the initialisefiles procedure. In that procedure, replace the path ':\Computer Science\Projects\' with the path to your new folder (for example, ':\A New Folder\' if your folder is named "A New Folder"). Additionally, please note that the password for the MainProgram login is "cs123". Access to the main system will be denied if the password is entered incorrectly. The password can be found in the createloginfile procedure within InitialProgram.

Remember to run the InitialProgram file before running the MainProgram file, as the test data must be initalised before being used. Additionally, if records are wiped due to an unforeseen circumstance, rerunning the InitialProgram file will restore the test data.

Useful Editor Shortcuts:

  Undo: Alt+Backspace
  
  Redo: Alt+Shift+Backspace
  
  Save: Ctrl+K+S or Shift+F2
  
  Open File: Shift+F3 or F3
  
  Close File: Alt+F3

For additional help, navigate to the Help menu, select Previous Topic, and open Editor Commands to view all available shortcuts and commands.
