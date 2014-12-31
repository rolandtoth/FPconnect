<h1>FPconnect</h1>

FPconnect is a [FoldersPopup](http://code.jeanlalonde.ca/folderspopup/) addon that allows integration of any file manager that supports commandline navigation.

<h2>Usage</h2>

<ol>
<li>Create a new folder "FPconnect" in FoldersPopup's directory</li>
<li>Copy "FPconnect.exe" and "FPconnect.ini" to the "FPconnect" directory</li>
<li>Set path to "FPconnect.exe" in FoldersPopup Settings ("Third-party File Managers Support" tab)</li>
<li>Set your custom file manager path and commandline parameters in FPconnect.ini</li>
</ol>

![Screenshot of FPconnect](https://github.com/rolandtoth/FPconnect/raw/master/FPconnect.png)

<h3>Download</h3>

[FPconnect.zip](https://github.com/rolandtoth/FPconnect/raw/master/FPconnect.zip)

<h3>Example</h3>

```
[Options]
AppPath=..\Double Commander\doublecmd.exe
Commandline=--no-console --client %NewTabSwitch% %Path%
NewTabSwitch=-T
```
See more examples and detailed documentation in [FPconnect.ini](https://github.com/rolandtoth/FPconnect/raw/master/FPconnect.ini).

<h3>Feedback</h3>

For feedback, bug reports and feature request please use the comment section here:
[http://blog.rolandtoth.hu/post/106133423662/fpconnect-for-folderspopup-windows](http://blog.rolandtoth.hu/post/106133423662/fpconnect-for-folderspopup-windows)

<h3>License</h3>

Licensed under the MIT license.

FPconnect is provided "as-is" without warranty of any kind, express, implied or otherwise,
including without limitation, any warranty of merchantability or fitness for a particular purpose.
In no event shall the author of this software be held liable for data loss, damages,
loss of profits or any other kind of loss while using or misusing this software.