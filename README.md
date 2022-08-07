# fatx-renamer
batch script to rename files for ogxbox
just drag and drop folder to the .bat file and will ask to copy or move with the new name, to a new folder_REN
I tired to make it similar to the "forcexbox" renaming option in good tools, however, I have limitation because of batch not having regex tools
will remove [=,+;] characters, then test for 38 char limit, if limit was not met, will remove spaces, then keep testing and removing other non essential characters before chopping the file name, will also add _number to every duplicate found, will also output a report file

this script its for educational purpose only :lol:

added the option to use short country codes (when renaming no-intro)

limitations: 
will only work with extensions with 3 characters
some characters in folder name may brake the scrip (need testing)
character [^] in file name may not show (need testing)

change log:

v1 now works with single files, and added some error checks, added the option to use short country codes

v2 added the option to remove parenthesis tags, and now will remove trailing spaces before checking for 38 char limit
