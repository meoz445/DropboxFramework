DropboxFramework
=================

**DropboxFramework HAS NO AFFILIATION WITH Dropbox**

DropboxFramework is a port of the official [Dropbox SDK][1] for iOS. It has no
affilation with [Dropbox][2], except for that they have given permission to
publish this code.

Note that Dropbox does not officially support desktop applications that use the
API. This means that you're in no way entitled to get an API key for a desktop
app, and you should contact Dropbox directly at [api-program@dropbox.com][4]
before even starting your project, asking if they'll allow you to use the API.

Most of the code is verbatim copied from the most recent (at the time of
writing) iOS SDK, [v0.2][3]. The new code resides in two places:

 * **Examples/** This contains example code that uses DropboxFramework.
 * **UI/** This contains code that manages the user interface.

In addition, the Resources/ directory contains all new graphical user
interfaces. This is the main point of DropboxFramework: A standard, clean user
interface to allow users to sign in (and link) their account to your app, and
to create a new account if they do not already have one.

[1]: http://www.dropbox.com/developers/releases "Dropbox SDKs"
[2]: http://www.dropbox.com/ "Dropbox"
[3]: http://www.dropbox.com/static/developers/dropbox-iphone-sdk-0.2.tar.gz "Objective-C/iOS SDK v0.2"
[4]: mailto:api-program@dropbox.com "API Program"
