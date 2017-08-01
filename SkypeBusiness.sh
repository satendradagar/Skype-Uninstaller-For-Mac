#!/bin/sh

#  SkypeBusiness.sh
#  SkypeUninstaller
#
#  Created by Satendra Singh(satendradagar@gmail.com) on 26/07/17.
#  Copyright © 2017 DomaiNYC. All rights reserved.


ver="1.0"
logname="$(logname)"
appName="Skype"
PreferencesName="com.skype.skype.plist"
ApplicationPath="/Applications/Skype.app"

TMPDIR="/tmp/"
TMP_SKYPE_DOWNLOAD="DOMAI_SKYPE"
download_page_url="https://dl.dropboxusercontent.com/s/2frw6bl3qkoeq0m/SkypeForBusinessInstaller-16.8.0.196.pkg?dl=0"
FullDownloadPath=$TMPDIR"Installer"$TMP_SKYPE_DOWNLOAD".pkg"


function CheckAndQuitSkype()
{
    pid=$(ps aux | grep $appName | grep -v grep  | awk '{print $2}')
    if [ -n "$pid" ]
        then
          echo "Skype is Running"
          echo "Stopping Skype"
          killall -KILL $appName
    else
          echo "Skype Is Not Running";
    fi
}

function CleanupSkypeData()
{
     SkypeSupportPath=$HOME"/Library/Application Support/$appName"
#     echo $SkypeSupportPath
     if [ -e "$SkypeSupportPath" ]
          then
          rm -rf "$SkypeSupportPath"
          echo "Application Support Deleted"

     else
          echo "Support Not Found"
     fi

     PreferencesPath=$HOME"/Library/Preferences/$PreferencesName"
#     echo $PreferencesPath
     if [ -e "$PreferencesPath" ]
          then
          rm "$PreferencesPath"
          echo "Preferences Deleted"
     else
          echo "Preferences Not Found"
     fi
#     echo $ApplicationPath
     if [ -e "$ApplicationPath" ]
          then
          echo "Deleting Application"
          sudo rm -rf "$ApplicationPath"
          echo "Application Deleted"

     else
     echo "Application Not Found"
     fi
}

function DownloadSkype()
{
#     echo $FullDownloadPath
     echo "Downloading Skype For Business"
     echo "-------------------------------------------------"
     curl -o "$FullDownloadPath" $download_page_url
     echo "-------------------------------------------------"
     echo "Download Completed"
}
function InstallSkype()
{
     echo "Installing Skype For Business"
     echo "-------------------------------------------------"
     sudo installer -verbose -pkg "$FullDownloadPath" -target /
     echo "-------------------------------------------------"
     echo "Installation Completed"

}

function CleanTempFiles()
{
     if [ -e "$FullDownloadPath" ]
          then
          echo "Deleting Temporary files"
          rm "$FullDownloadPath"
          echo "Deleted Temporary files"
     fi
}

function FinishInstallation()
{
     echo "Finalising Installaton"
     CleanTempFiles
     echo "Installaton Completed"

}

function Main()
{
     echo "-------------------------------------------------"
     echo "Initialising..."
     CheckAndQuitSkype
     CleanupSkypeData
     DownloadSkype
     InstallSkype
     FinishInstallation
     echo "-------------------------------------------------"

}
Main
