# Log4Swift

Log4Swift is loosely based on the original Log4J and it's successor Logback.  Despite Log4J presenting an excellent logging framework before Java had it's own, the makers of Java felt, for some reason, that a lobotimized logging framework was what they wanted instead.  Naturally Android and Swift have followed suit with absurdly useless logging frameworks which encourage developers to simply avoid logging as much as possible.

In contrast Log4J and Log4Swft are configurable and can be set to log as much or as little as needed before or, perhaps, during logging.  It can also be wholly deactivated to maximize performance on release.  

Beside configurability, Log4J allows the implementation of custom Loggers for special purposes like logging to a database or to different files.  Log4Swift has just begun but is already significantly more advanced than debugPrint or XLogger.

To configure Log4Swift in an app, place a Log4Swift.config file in the Resources or DeveloperAssets directories.  The format is JSON and looks like;

```json
{
	"threshold": ["WARN", "TIME"],
	"subsystem": "XLogger Subsystem",
	"category": "XLogger Category"
}
```

The values for threshold are one of 

DEBUG, INFO, WARN, ERROR

and one or more of 

SPECIAL, TIME, DATA_DUMPS

DEBUG, INFO, WARN & ERROR each limit the logging of lower levels so WARN will log WARN & ERROR but not DEBUG or INFO.
SPECIAL, TIME & DATA_DUMPS serve special functions
OFF overrides all logging and prevents any logging from occurring

To use the default logger simple use the singleton - 

```
Log.shared.debug("This is a debug statement")
```

The output is not simply the message but also shows the file and line where the log statement was made

```
2022-10-07 14:38:16.732975-0500 xctest[13136:190224] [category] Debug Statement (Log4SwiftTests.swift:9)
```

Log4Swift includes special functions for timing blocks of code.  This is useful for finding bottlenecks.  To time section of code or a function use

```
Log.shared.markTimerStart("Starting process")
myprocess()
Log.shared.markTime("First process done.")
secondProcess()
Log.shared.markTimerEnd("Finished both processes")
```

The output shows the times and the duration of time passed.

```
2022-10-07 14:38:16.733151-0500 xctest[13136:190224] [category] Starting process (Log4SwiftTests.swift:11)
2022-10-07 14:38:31.720943-0500 xctest[13136:190224] [category] First process done. at 19:38:16.733 (0.003 ms) (Log4SwiftTests.swift:12)
2022-10-07 14:38:31.721230-0500 xctest[13136:190224] [category] Finished both processes at 19:38:31.721 (14.988 sec) (Log4SwiftTests.swift:13)
```

The timer functions also allow for a blockId so you can run different timers together.

=====

Admittedly, I hate writing documentation.  More later.
