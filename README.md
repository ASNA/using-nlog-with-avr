# Using NLog with AVR 

## 1. Install NLog with Nuget Package Manager

```
Install-Package NLog.Config
```

I got several scary-looking errors during the install (when installing from the Package Manager Console) but the installed finished and did work.  

![https://asna-assets.nyc3.cdn.digitaloceanspaces.com/asna-com/nlog-install-errors-12-20-57-51.webp](https://asna-assets.nyc3.cdn.digitaloceanspaces.com/asna-com/nlog-install-errors-12-20-57-51.webp)

## 2. Update NLog.config

Installing NLog puts an `NLog.config` file in the root of your project. Remove its contents and replace with: 

```xml
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <targets>
        <!-- Writes logs to a file in the App_Data/Logs folder -->
        <target xsi:type="File"
                name="fileTarget"
                fileName="${basedir}/App_Data/Logs/${shortdate}.log"
                layout="${longdate} | ${level:uppercase=true} | ${logger} | ${message} ${exception:format=tostring}" />
    </targets>

    <rules>
        <!-- Log everything from Info level and higher -->
        <logger name="*" minlevel="Info" writeTo="fileTarget" />
    </rules>
</nlog>
```

The `fileName` value provides the filename for the log. The first time your app writes a log entry, the `{basedir}` in the configuration above, causes the logs to be written to a file named `yyyy-mm-dd.log` in the `/App_Code` (from the root of your application.) With this configuration, a unique log is created for each day. 

The `layout` value provides the template for the text written to the log. The `rules` section is discussed further below in this article.

![https://asna-assets.nyc3.cdn.digitaloceanspaces.com/asna-com/nlog-in-solution-explorer-12-26-37-46.webp](https://asna-assets.nyc3.cdn.digitaloceanspaces.com/asna-com/nlog-in-solution-explorer-12-26-37-46.webp)

The figure above shows the Solution Explorer view after a log entry has been written. You may need to reload your project the first time a log is created to see the `App_Data` folder in the Solution Explorer.

## 3. Add the `Log` instance to your code

Add this line to the mainline area of any codebehind `aspx.vr` file: 

```
DclFld Log Type(NLog.Logger) Access(*Private)
```

Then, in `Page_Load`, assign the NLog static instance to `Log`:

```
BegSr Page_Load Access(*Private) Event(*This.Load)
	DclSrParm sender Type(*Object)
	DclSrParm e Type(System.EventArgs)

	If (Log = *Nothing)
		Log = NLog.LogManager.GetCurrentClassLogger()
	EndIf
	...
EndSr		
```

This makes a `Log` instance available to the page with which you can write messages to the log file. 

## 4. Write to the log file

```
Log.Info("I am out of coffee.")
```

There are six methods for writing to the log; each conveys the level of the log entry. 

- *Trace*: Very detailed logs (typically disabled in production).
- *Debug*: Debugging information.
- *Info*: Normal app behavior (Start/Stop/Page Load).
- *Warn*: Something unexpected happened, but the app is still running.
- *Error*: Something failed (Exceptions).
- *Fatal*: The application crashed.

The configuration above sets the minimal log level. In this example it is sent to `Info`:

```
<rules>
    <!-- Log everything from Info level and higher -->
	<logger name="*" minlevel="Info" writeTo="fileTarget" />
</rules>
```



