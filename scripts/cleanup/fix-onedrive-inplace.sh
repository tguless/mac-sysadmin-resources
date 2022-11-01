cd ~
loggedinuser="$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')"
onedrivefolder="/Users/""$loggedinuser""/OneDrive - Rocket Pharma/"

curl -o fix-onedrive-filenames-apfs.sh https://raw.githubusercontent.com/tguless/mac-sysadmin-resources/master/scripts/cleanup/fix-onedrive-filenames-apfs.sh
chmod u+x ./fix-onedrive-filenames-apfs.sh

echo Fixing filnames in "${onedrivefolder}"
./fix-onedrive-filenames-apfs.sh "${onedrivefolder}"