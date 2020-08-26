# FindMyPlant
![Image of FindMyPlant](https://github.com/LuisAlor/FindMyPlant/blob/master/gitImages/project-banner.png)

**FindMyPlant** is a project created for Udacity iOS Developer Nanodegree. This application lets users to find random plants, edible plants, search for any desired plant and to add to favorites the plants you like. FindMyPlant app uses Firebase for requesting and storing data to Firestore, and Trefle.io (a API for plants still in development) for requesting plants information.

## Requirements
For using this project you must meet the next requirements:
1. An Apple's Mac computer
2. Xcode installed - https://apps.apple.com/ru/app/xcode/id497799835?l=en&mt=12
3. Cocoapods installed - https://cocoapods.org/
4. Firebase account and Firestore DB configured - https://firebase.google.com/
5. Trefle.io account to get your own API Key - https://trefle.io/users/sign_up

## Installation
In order to get FindMyPlant running, you must follow the next steps:
1. Install CocoaPods (If not installed already in your system using Terminal)
```
$ sudo gem install cocoapods
```
2. In your Terminal run the following code to access the project's folder and install the necessary pods:
```
$ cd ~/FindMyPlant
$ pod install
```
3. When installation completes open the workspace created with the following command:
```
$ open FindMyPlant.xcworkspace
```
## Trefle API Key
Trefle API Key is not stored in the app for security purposes, in order to setup your Firestore to save the apiKey and your app to retrieve it you must follow the next steps:

1. Setup Cloud Firestore 
2. Create a collection named: applicationKeys
3. Create inside the previous collection a document named: TrefleAPI
4. Finally add a field named: apiKey of Type String and copy paste your API Key there
5. The rest the app will do by itself.

**Detailed Firestore setup:**
![Image of Firestore Setup](https://github.com/LuisAlor/FindMyPlant/blob/master/gitImages/firestore_apikey_setup.png)

## Setup Firebase to FindMyPlant
For Firebase to connect to the app, you must download the file named: **GoogleService-Info.plist** that was generated after you created your application project in Firebase console. This file contains configuration details such as keys and identifiers, for the services you just enabled. Without this file the project will not work. 

**Recommendation:** The file **GoogleService-Info.plist** can be added to Support Files folder in FindMyPlant project
