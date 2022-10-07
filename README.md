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
