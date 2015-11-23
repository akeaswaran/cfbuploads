# cfbuploads
An iPhone app for the /r/CFBUploads subreddit.

## Installation

Make sure you have CocoaPods installed on your computer. After cloning the repo to your computer, run `pod install` on the cfbuploads directory to install all of the third-party libraries. Then, open cfbuploads.xcworkspace and follow along below.

* Open the project settings by clicking the top-most cfbuploads folder in Xcode's left sidebar. For the product name, enter a reverse URL that is not what is already there (EX: com.githubuser.cfbuploads).
* Open Xcode's Preferences, and add your Apple ID to the "Accounts" tab.
* Then, navigate back to the project settings, and click "Fix Issue".
* Plug in your iDevice. Look at the toolbar at the top of the window. Click "iPhone 6S" or whatever appears on the right of "cfbuploads", then scroll to your device and select it.
* Wait for Xcode to finish checking symbols, and then click the Run button in the top left (the Play button). Ignore any warnings, but if there are errors, please let me know by [creating an issue](https://github.com/akeaswaran/cfbuploads/issues/new).
* On you device, you should see the app appear and open. If an alert appears on your screen saying the identity of the developer can not be verified, go to Settings, navigate to General > Profiles, and allow your development profile. The app should then work on the next run.

## Requirements

CFBUploads requires iOS 9.0 and Xcode 7 or greater.

## Dependencies

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [ApolloDB](https://github.com/jchomali/ApolloDB)
* [DFCache](https://github.com/kean/DFCache)
* [Mantle](https://github.com/github/Mantle)
* [RedditKit](https://github.com/samsymons/RedditKit)
* [SUBLicenseViewController](https://github.com/insanj/SUBLicenseViewController)
* [XCDYoutubeKit](https://github.com/0xced/XCDYouTubeKit)

## Need Help?

Open an [issue](https://github.com/akeaswaran/cfbuploads/issues/new).

###License

See [LICENSE.md](https://github.com/akeaswaran/cfbuploads/blob/master/LICENSE.md) for details. 

