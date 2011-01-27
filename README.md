DropboxFramework
=================

DropboxFramework is a port of the official [Dropbox SDK][1] for iOS. It has
**no affilation with [Dropbox][2]**, except that they have given permission to
publish this code.

DropboxFramework contains the standard ObjectiveC SDK that should be familiar
to developers who have used it on iOS, as well as a clean user interface that
the application developer can easily invoke. All of this is wrapped into a OS X
.framework file, so that you can quickly get started using the Dropbox API in
your own app.

Note that Dropbox does not officially support desktop applications that use the
API. This means that you're in no way entitled to get an API key for a desktop
app, and you should contact Dropbox directly at [api-program@dropbox.com][4]
before even starting your project, asking if they'll allow you to use the API.

Most of the code is verbatim copied from the most recent (at the time of
writing) iOS SDK, [v0.2][3]. The new code resides in two places:

 * **Examples/** This contains example code that uses DropboxFramework.
 * **UI/** This contains code that manages the user interface.

In addition, the **Resources/** directory contains all new graphical user
interfaces. This is the main point of DropboxFramework: A standardized and
clean user interface that developers can easily use. The user interface should
allow users to sign in and link their account to your app, and to create a new
account if they do not already have one. It is also beneficial to have a user
interface users might "recognize", if they've used other Dropbox-powered
applications.

The interface looks like this, at the time of writing:
![Linking account to your app][5]
![Creating a new Dropbox account][6]


[1]: http://www.dropbox.com/developers/releases "Dropbox SDKs"
[2]: http://www.dropbox.com/ "Dropbox"
[3]: http://www.dropbox.com/static/developers/dropbox-iphone-sdk-0.2.tar.gz "Objective-C/iOS SDK v0.2"
[4]: mailto:api-program@dropbox.com "API Program"

[5]: http://dl.dropbox.com/u/987046/Screenshots/link_account.jpg "Initial linking"
[6]: http://dl.dropbox.com/u/987046/Screenshots/create_account.jpg "Account creation"
