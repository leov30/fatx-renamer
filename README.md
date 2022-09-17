# fatx-renamer
batch script to rename files for ogxbox
I tired to make it similar to the "forcexbox" renaming option in good tools, however, I have limitation because of batch not having regex tools
will remove [=,+;] characters, then test for 38 char limit, if limit was not met, will remove spaces, then keep testing and removing other non essential characters before chopping the file name, will also add _number to every duplicate found, will also output a report file

# usage
just drag and drop folder to the .bat file and will ask to copy or move with the new name, to a new folder_REN
will show options: 

use short counry codes similar to goodtools, save country code but make the title short, remove parenthesis tags, chop the filename with the parenthesis tags.

* limitations: 
will only work with extensions with 3 characters
character [^] in file name may not show (need testing)
parenthesis tags are only for no-intro file names

