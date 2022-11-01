
function migrateOneDrive() {
   cd ~
   local -r loggedinuser="$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')"
   local -r onedrivefolder="/Users/""$loggedinuser""/OneDrive - Rocket Pharma"
   echo "Running Test"
   echo $onedrivefolder
   
   today=$(date +"%Y-%m-%d")

   mkdir -p "$onedrivefolder/Laptop-Documents-${today}/"
   mkdir -p "$onedrivefolder/Laptop-Desktop-${today}/"

   curl -o fix-onedrive-filenames-apfs.sh https://raw.githubusercontent.com/tguless/mac-sysadmin-resources/master/scripts/cleanup/fix-onedrive-filenames-apfs.sh
   chmod u+x ./fix-onedrive-filenames-apfs.sh
   ./fix-onedrive-filenames-apfs.sh

   local -r loggedinuser="$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')"
   local -r documentsfolder="/Users/""$loggedinuser""/Documents"
   local -r desktopfolder="/Users/""$loggedinuser""/Desktop"

   ./fix-onedrive-filenames-apfs.sh "$documentsfolder"
   ./fix-onedrive-filenames-apfs.sh "$desktopfolder"

   today=$(date +"%Y-%m-%d")

   cd "/Users/$loggedinuser/Desktop/"
   find ./*  -not -path "/Users/$loggedinuser/Desktop/"Onedrive  -type d -exec mkdir -p "$onedrivefolder/Laptop-Desktop-${today}/"{} \;
   find ./*  -not -path "/Users/$loggedinuser/Desktop/"Onedrive  -type f -exec mv {} "$onedrivefolder/Laptop-Desktop-${today}/"{} \;
   find ./ -depth -type d -empty -exec rmdir {} \;

   cd "/Users/$loggedinuser/Documents/"
   find ./*  -not -path "/Users/$loggedinuser/Documents/"Onedrive -type d -exec mkdir -p "$onedrivefolder/Laptop-Documents-${today}/"{} \;
   find ./*  -not -path "/Users/$loggedinuser/Documents/"Onedrive -type f -exec mv {} "$onedrivefolder/Laptop-Documents-${today}/"{} \;
   find ./ -depth -type d -empty -exec rmdir {} \;


   ln -sfn "$onedrivefolder/Laptop-Documents/" /Users/$loggedinuser/Documents/Onedrive
   ln -sfn "$onedrivefolder/Laptop-Desktop/" /Users/$loggedinuser/Desktop/Onedrive 
}

migrateOneDrive

