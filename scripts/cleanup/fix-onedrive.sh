
function migrateOneDrive() {
   cd ~
   local -r loggedinuser="$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')"
   local -r onedrivefolder="/Users/""$loggedinuser""/OneDrive - Rocket Pharma"
   echo "Running Test"
   echo $onedrivefolder
   
   mkdir -p "$onedrivefolder/Laptop-Documents/"
   mkdir -p "$onedrivefolder/Laptop-Desktop/"

   curl -o fix-onedrive-filenames-apfs.sh https://raw.githubusercontent.com/tguless/mac-sysadmin-resources/master/scripts/cleanup/fix-onedrive-filenames-apfs.sh
   chmod u+x ./fix-onedrive-filenames-apfs.sh
   ./fix-onedrive-filenames-apfs.sh

   cd "/Users/$loggedinuser/Desktop/"
   find ./*  -not -path "/Users/$loggedinuser/Desktop/"Onedrive  -maxdepth 1 -type d -exec mkdir -p "$onedrivefolder/Laptop-Desktop/"{} \;
   find ./*  -not -path "/Users/$loggedinuser/Desktop/"Onedrive  -maxdepth 1 -type f -exec mv {} "$onedrivefolder/Laptop-Desktop/"{} \;
   find ./ -depth -type d -empty -exec rmdir {} \;

   cd "/Users/$loggedinuser/Documents/"
   find ./*  -not -path "/Users/$loggedinuser/Documents/"Onedrive  -maxdepth 1 -type d -exec mkdir -p "$onedrivefolder/Laptop-Documents/"{} \;
   find ./*  -not -path "/Users/$loggedinuser/Documents/"Onedrive  -maxdepth 1 -type f -exec mv {} "$onedrivefolder/Laptop-Documents/"{} \;
   find ./ -depth -type d -empty -exec rmdir {} \;


   ln -sfn "$onedrivefolder/Laptop-Documents/" /Users/$loggedinuser/Documents/Onedrive
   ln -sfn "$onedrivefolder/Laptop-Desktop/" /Users/$loggedinuser/Desktop/Onedrive 
}

migrateOneDrive

