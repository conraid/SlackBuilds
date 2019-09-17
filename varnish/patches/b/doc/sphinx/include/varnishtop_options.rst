-1

	Instead of a continuously updated display, print the statistics once and exit. Implies ``-d``.

-b

	Only display transactions and log records coming from backend communication.

-c

	Only display transactions and log records coming from client communication.

-C

	Do all regular expression and string matching caseless.

-d

	Process log records at the head of the log.

-f

	Sort and group only on the first field of each log entry. For log entries in the form ``prefix: value`` it is the prefix without the colon that is sorted and grouped. This is useful when displaying e.g. ReqStart entries, where the first field is the client IP address.

-g <session|request|vxid|raw>

	The grouping of the log records. The default is to group by vxid.

-h

	Print program usage and exit

-i <taglist>

	Include log records of these tags in output. Taglist is a comma-separated list of tag globs. Multiple -i options may be given.
	
	If a tag include option is the first of any tag selection options, all tags are first marked excluded.

-I <[taglist:]regex>

	Include by regex matching. Output only records matching taglist and regular expression. Applies to any tag if taglist is absent. Multiple -I options may be given.
	
	If a tag include option is the first of any tag selection options, all tags are first marked excluded.

-L <limit>

	Sets the upper limit of incomplete transactions kept before the oldest transaction is force completed. A warning record is synthesized when this happens. This setting keeps an upper bound on the memory usage of running queries. Defaults to 1000 transactions.

-n <dir>

	Specify the varnishd working directory (also known as instance name) to get logs from. If -n is not specified, the host name is used.

-p <period>

	Specified the number of seconds to measure over, the default is 60 seconds. The first number in the list is the average number of requests seen over this time period. This option has no effect if -1 option is also used.

-Q <file>

	Specifies the file containing the VSL query to use. When multiple -Q or -q options are specified, all queries are considered as if the 'or' operator was used to combine them.

-q <query>

	Specifies the VSL query to use. When multiple -q or -Q options are specified, all queries are considered as if the 'or' operator was used to combine them.

-r <filename>

	Read log in binary file format from this file. The file can be created with ``varnishlog -w filename``.

-t <seconds|off>

	Timeout before returning error on initial VSM connection. If set the VSM connection is retried every 0.5 seconds for this many seconds. If zero the connection is attempted only once and will fail immediately if unsuccessful. If set to "off", the connection will not fail, allowing the utility to start and wait indefinetely for the Varnish instance to appear.  Defaults to 5 seconds.

-T <seconds>

	Sets the transaction timeout in seconds. This defines the maximum number of seconds elapsed between a Begin tag and the End tag. If the timeout expires, a warning record is synthesized and the transaction is force completed. Defaults to 120 seconds.

-x <taglist>

	Exclude log records of these tags in output. Taglist is a comma-separated list of tag globs. Multiple -x options may be given.


-X <[taglist:]regex>

	Exclude by regex matching. Do not output records matching taglist and regular expression. Applies to any tag if taglist is absent. Multiple -X options may be given.


-V

	Print version information and exit.

--optstring
	Print the optstring parameter to ``getopt(3)`` to help writing wrapper scripts.

