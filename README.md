JavaScriptCore libraries
========================
The purpose of this project is to deliver JavaScriptCore pre-compiled and pre-packaged for all supported platforms so
that it may be easily dropped into projects for immediate use. It will also come shipped with all the Makefiles used to
compile the libraries so that users may inspect the options used as well as re-compile the libraries if they see it
necessary.

Branching & Tagging
---------------


Compile options
---------------
For performance and immediate production use reasons, all libraries are compiled using the default release options
present in the JavaScriptCore Makefiles.

Compression
-----------


Platforms
---------
The following platforms are supported by this project and will be present within their respective build folders:
 * Android ()
 * Linux ()
 * Windows ()
 * Windows Phone 8 ()

The following platforms already contain libraries as part of their respective SDKs and will not be present inside the
build folder. However our test applications will link against these available SDKs to ensure code use consistency.
 * IOS ()
 * MacOSX ()

**NOTES:**
 * 

Licenses
--------
All original code and scripts within the project are subject to the [MIT license](LICENSE)

All dependencies and their compiled binary files are subject to their original respective licenses as found in their
respective repositories.