-B <factor>

	Factor to bend time by. Particularly useful when [-r]eading from a vsl file. =1 process in near real time, <1 slow-motion, >1 time-lapse (useless unless reading from a file). At runtime, < halves and > doubles.

-C

	Do all regular expression and string matching caseless.

-d

	Process log records at the head of the log and exit.

-g <request|vxid>

	The grouping of the log records. The default is to group by vxid.

-h

	Print program usage and exit

-L <limit>

	Sets the upper limit of incomplete transactions kept before the oldest transaction is force completed. A warning record is synthesized when this happens. This setting keeps an upper bound on the memory usage of running queries. Defaults to 1000 transactions.

-n <dir>

	Specify the varnishd working directory (also known as instance name) to get logs from. If -n is not specified, the host name is used.

-p <period>

	Specified the number of seconds between screen refreshes. Default is 1 second, and can be changed at runtime by pressing the [0-9] keys (powers of 2 in seconds or + and - (double/halve the speed).

-P responsetime

	Predefined client profile: graph the total time from start of request processing (first byte received) until ready to deliver the client response (field 3 of SLT_Timestamp Process: VSL tag).

-P reqbodytime

	Predefined client profile: graph the time for reading the request body (field 3 of SLT_Timestamp ReqBody: VSL tag).

-P size

	Predefined client profile: graph the size of responses (field 5 of SLT_ReqAcct  VSL tag).

-P Bereqtime

	Predefined backend profile: graph the time from beginning of backend processing until a backend request is sent completely (field 3 of SLT_Timestamp Bereq: VSL tag).

-P Beresptime

	Predefined backend profile: graph the time from beginning of backend processing until the response headers are being received completely (field 3 of SLT_Timestamp Beresp: VSL tag).

-P BerespBodytime

	Predefined backend profile: graph the time from beginning of backend processing until the response body has been received (field 3 of SLT_Timestamp BerespBody: VSL tag).

-P Besize

	Predefined backend profile: graph the backend response body size (field 5 of SLT_BereqAcct  VSL tag).

-P <[cb:]tag:[prefix]:field_num[:min:max]>

	Graph the given custom definition defined as: an optional (c)lient or (b)ackend filter (defaults to client), the tag we'll look for, a prefix to look for (can be empty, but must be terminated by a colon) and the field number of the value we are interested in. min and max are the boundaries of the graph in powers of ten and default to -6 and 3.

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

-V

	Print version information and exit.

--optstring
	Print the optstring parameter to ``getopt(3)`` to help writing wrapper scripts.

