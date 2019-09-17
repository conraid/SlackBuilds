Backend - Backend selected
	Logged when a connection is selected for handling a backend request.
	
	The format is::
	
		%d %s %s
		|  |  |
		|  |  +- Backend display name
		|  +---- VCL name
		+------- Connection file descriptor
	
		NOTE: This tag is currently not in use in the Varnish log.
		It is mentioned here to document legacy versions of the log,
		or reserved for possible use in future versions.
	


BackendClose - Backend connection closed
	Logged when a backend connection is closed.
	
	The format is::
	
		%d %s [ %s ]
		|  |    |
		|  |    +- Optional reason
		|  +------ Backend display name
		+--------- Connection file descriptor
	


BackendOpen - Backend connection opened
	Logged when a new backend connection is opened.
	
	The format is::
	
		%d %s %s %s %s %s
		|  |  |  |  |  |
		|  |  |  |  |  +- Local port
		|  |  |  |  +---- Local address
		|  |  |  +------- Remote port
		|  |  +---------- Remote address
		|  +------------- Backend display name
		+---------------- Connection file descriptor
	


BackendReuse - Backend connection put up for reuse
	Logged when a backend connection is put up for reuse by a later connection.
	
	The format is::
	
		%d %s
		|  |
		|  +- Backend display name
		+---- Connection file descriptor
	


BackendStart - Backend request start
	Start of backend processing. Logs the backend IP address and port number.
	
	The format is::
	
		%s %s
		|  |
		|  +- Backend Port number
		+---- Backend IP4/6 address
	
		NOTE: This tag is currently not in use in the Varnish log.
		It is mentioned here to document legacy versions of the log,
		or reserved for possible use in future versions.
	


Backend_health - Backend health check
	The result of a backend health probe.
	
	The format is::
	
		%s %s %s %s %u %u %u %f %f %s
		|  |  |  |  |  |  |  |  |  |
		|  |  |  |  |  |  |  |  |  +- Probe HTTP response / error information
		|  |  |  |  |  |  |  |  +---- Average response time
		|  |  |  |  |  |  |  +------- Response time
		|  |  |  |  |  |  +---------- Probe window size
		|  |  |  |  |  +------------- Probe threshold level
		|  |  |  |  +---------------- Number of good probes in window
		|  |  |  +------------------- Probe window bits
		|  |  +---------------------- "healthy" or "sick"
		|  +------------------------- "Back", "Still" or "Went"
		+---------------------------- Backend name
	
	Probe window bits are::
	
		'4': Good IPv4
		'6': Good IPv6
		'U': Good UNIX
		'x': Error Xmit
		'X': Good Xmit
		'r': Error Recv
		'R': Good Recv
		'H': Happy
	


Begin - Marks the start of a VXID
	The first record of a VXID transaction.
	
	The format is::
	
		%s %d %s
		|  |  |
		|  |  +- Reason
		|  +---- Parent vxid
		+------- Type ("sess", "req" or "bereq")
	


BereqAcct - Backend request accounting
	Contains byte counters from backend request processing.
	
	The format is::
	
		%d %d %d %d %d %d
		|  |  |  |  |  |
		|  |  |  |  |  +- Total bytes received
		|  |  |  |  +---- Body bytes received
		|  |  |  +------- Header bytes received
		|  |  +---------- Total bytes transmitted
		|  +------------- Body bytes transmitted
		+---------------- Header bytes transmitted
	


BereqHeader - Backend request header
	HTTP header contents.
	
	The format is::
	
		%s: %s
		|   |
		|   +- Header value
		+----- Header name
	


BereqMethod - Backend request method
	The HTTP request method used.
	


BereqProtocol - Backend request protocol
	The HTTP protocol version information.
	


BereqURL - Backend request URL
	The HTTP request URL.
	


BerespHeader - Backend response header
	HTTP header contents.
	
	The format is::
	
		%s: %s
		|   |
		|   +- Header value
		+----- Header name
	


BerespProtocol - Backend response protocol
	The HTTP protocol version information.
	


BerespReason - Backend response response
	The HTTP response string received.
	


BerespStatus - Backend response status
	The HTTP status code received.
	


BogoHeader - Bogus HTTP received
	Contains the first 20 characters of received HTTP headers we could not make sense of.  Applies to both req.http and beresp.http.
	


CLI - CLI communication
	CLI communication between varnishd master and child process.
	


Debug - Debug messages
	Debug messages can normally be ignored, but are sometimes helpful during trouble-shooting.  Most debug messages must be explicitly enabled with parameters.
	
	Debug messages may be added, changed or removed without prior notice and shouldn't be considered stable.
	
	NB: This log record is masked by default.
	


ESI_xmlerror - ESI parser error or warning message
	An error or warning was generated during parsing of an ESI object. The log record describes the problem encountered.

End - Marks the end of a VXID
	The last record of a VXID transaction.
	


Error - Error messages
	Error messages are stuff you probably want to know.
	


ExpBan - Object evicted due to ban
	Logs the VXID when an object is banned.
	


ExpKill - Object expiry event
	Logs events related to object expiry. The events are:
	
	EXP_Rearm
		Logged when the expiry time of an object changes.
	
	EXP_Inbox
		Logged when the expiry thread picks an object from the inbox for processing.
	
	EXP_Kill
		Logged when the expiry thread kills an object from the inbox.
	
	EXP_When
		Logged when the expiry thread moves an object on the binheap.
	
	EXP_Expired
		Logged when the expiry thread expires an object.
	
	LRU_Cand
		Logged when an object is evaluated for LRU force expiry.
	
	LRU
		Logged when an object is force expired due to LRU.
	
	LRU_Fail
		Logged when no suitable candidate object is found for LRU force expiry.
	
	The format is::
	
		EXP_Rearm p=%p E=%f e=%f f=0x%x
		EXP_Inbox p=%p e=%f f=0x%x
		EXP_Kill p=%p e=%f f=0x%x
		EXP_When p=%p e=%f f=0x%x
		EXP_Expired x=%u t=%f
		LRU_Cand p=%p f=0x%x r=%d
		LRU x=%u
		LRU_Fail
		
		Legend:
		p=%p         Objcore pointer
		t=%f         Remaining TTL (s)
		e=%f         Expiry time (unix epoch)
		E=%f         Old expiry time (unix epoch)
		f=0x%x       Objcore flags
		r=%d         Objcore refcount
		x=%u         Object VXID
	


FetchError - Error while fetching object
	Logs the error message of a failed fetch operation.
	
	Error messages should be self-explanatory, yet the http connection(HTC) class of errors is reported with these symbols:
	
		* junk (-5): Received unexpected data
		* close (-4): Connection closed
		* timeout (-3): Timed out
		* overflow (-2): Buffer/workspace too small
		* eof (-1): Unexpected end of input
		* empty (0): Empty response
		* more (1): More data required
		* complete (2): Data complete (no error)
		* idle (3): Connection was closed while idle
	
	Notice that some HTC errors are never emitted.

Fetch_Body - Body fetched from backend
	Ready to fetch body from backend.
	
	The format is::
	
		%d (%s) %s
		|   |    |
		|   |    +---- 'stream' or '-'
		|   +--------- Text description of body fetch mode
		+------------- Body fetch mode
	


Filters - Body filters
	List of filters applied to the body

Gzip - G(un)zip performed on object
	A Gzip record is emitted for each instance of gzip or gunzip work performed. Worst case, an ESI transaction stored in gzip'ed objects but delivered gunziped, will run into many of these.
	
	The format is::
	
		%c %c %c %d %d %d %d %d
		|  |  |  |  |  |  |  |
		|  |  |  |  |  |  |  +- Bit length of compressed data
		|  |  |  |  |  |  +---- Bit location of 'last' bit
		|  |  |  |  |  +------- Bit location of first deflate block
		|  |  |  |  +---------- Bytes output
		|  |  |  +------------- Bytes input
		|  |  +---------------- 'E': ESI, '-': Plain object
		|  +------------------- 'F': Fetch, 'D': Deliver
		+---------------------- 'G': Gzip, 'U': Gunzip, 'u': Gunzip-test
	
	Examples::
	
		U F E 182 159 80 80 1392
		G F E 159 173 80 1304 1314
	


H2RxBody - Received HTTP2 frame body
	Binary data

H2RxHdr - Received HTTP2 frame header
	Binary data

H2TxBody - Transmitted HTTP2 frame body
	Binary data

H2TxHdr - Transmitted HTTP2 frame header
	Binary data

Hash - Value added to hash
	This value was added to the object lookup hash.
	
	NB: This log record is masked by default.
	


Hit - Hit object in cache
	Object looked up in cache.
	
	The format is::
	
		%u %f %f %f
		|  |  |  |
		|  |  |  +- Keep period
		|  |  +---- Grace period
		|  +------- Remaining TTL
		+---------- VXID of the object
	


HitMiss - Hit for miss object in cache.
	Hit-for-miss object looked up in cache.
	
	The format is::
	
		%u %f
		|  |
		|  +- Remaining TTL
		+---- VXID of the object
	


HitPass - Hit for pass object in cache.
	Hit-for-pass object looked up in cache.
	
	The format is::
	
		%u %f
		|  |
		|  +- Remaining TTL
		+---- VXID of the object
	


HttpGarbage - Unparseable HTTP request
	Logs the content of unparseable HTTP requests.
	


Length - Size of object body
	Logs the size of a fetch object body.
	


Link - Links to a child VXID
	Links this VXID to any child VXID it initiates.
	
	The format is::
	
		%s %d %s
		|  |  |
		|  |  +- Reason
		|  +---- Child vxid
		+------- Child type ("req" or "bereq")
	


LostHeader - Failed attempt to set HTTP header
	Logs the header name of a failed HTTP header operation due to resource exhaustion or configured limits.
	


ObjHeader - Object  header
	HTTP header contents.
	
	The format is::
	
		%s: %s
		|   |
		|   +- Header value
		+----- Header name
	


ObjProtocol - Object  protocol
	The HTTP protocol version information.
	


ObjReason - Object  response
	The HTTP response string received.
	


ObjStatus - Object  status
	The HTTP status code received.
	


PipeAcct - Pipe byte counts
	Contains byte counters for pipe sessions.
	
	The format is::
	
		%d %d %d %d
		|  |  |  |
		|  |  |  +------- Piped bytes to client
		|  |  +---------- Piped bytes from client
		|  +------------- Backend request headers
		+---------------- Client request headers
	


Proxy - PROXY protocol information
	PROXY protocol information.
	
	The format is::
	
		%d %s %d %s %d
		|  |  |  |  |
		|  |  |  |  +- server port
		|  |  |  +---- server ip
		|  |  +------- client port
		|  +---------- client ip
		+------------- PROXY protocol version
		
		All fields are "local" for PROXY local connections (command 0x0)
	


ProxyGarbage - Unparseable PROXY request
	A PROXY protocol header was unparseable.
	


ReqAcct - Request handling byte counts
	Contains byte counts for the request handling.
	The body bytes count includes transmission overhead (ie: chunked encoding).
	ESI sub-requests show the body bytes this ESI fragment including any subfragments contributed to the top level request.
	The format is::
	
		%d %d %d %d %d %d
		|  |  |  |  |  |
		|  |  |  |  |  +- Total bytes transmitted
		|  |  |  |  +---- Body bytes transmitted
		|  |  |  +------- Header bytes transmitted
		|  |  +---------- Total bytes received
		|  +------------- Body bytes received
		+---------------- Header bytes received
	


ReqHeader - Client request header
	HTTP header contents.
	
	The format is::
	
		%s: %s
		|   |
		|   +- Header value
		+----- Header name
	


ReqMethod - Client request method
	The HTTP request method used.
	


ReqProtocol - Client request protocol
	The HTTP protocol version information.
	


ReqStart - Client request start
	Start of request processing. Logs the client address, port number  and listener endpoint name (from the -a command-line argument).
	
	The format is::
	
		%s %s %s
		|  |  |
		|  |  +-- Listener name (from -a)
		|  +----- Client Port number (0 for Unix domain sockets)
		+-------- Client IP4/6 address (0.0.0.0 for UDS)
	


ReqURL - Client request URL
	The HTTP request URL.
	


RespHeader - Client response header
	HTTP header contents.
	
	The format is::
	
		%s: %s
		|   |
		|   +- Header value
		+----- Header name
	


RespProtocol - Client response protocol
	The HTTP protocol version information.
	


RespReason - Client response response
	The HTTP response string received.
	


RespStatus - Client response status
	The HTTP status code received.
	


SessClose - Client connection closed
	SessClose is the last record for any client connection.
	
	The format is::
	
		%s %f
		|  |
		|  +- How long the session was open
		+---- Why the connection closed
	


SessError - Client connection accept failed
	Accepting a client connection has failed.
	
	The format is::
	
		%s %s %s %d %d %s
		|  |  |  |  |  |
		|  |  |  |  |  +- Detailed error message
		|  |  |  |  +---- Error Number (errno) from accept(2)
		|  |  |  +------- File descriptor number
		|  |  +---------- Local TCP port / 0 for UDS
		|  +------------- Local IPv4/6 address / 0.0.0.0 for UDS
		+---------------- Socket name (from -a argument)
	


SessOpen - Client connection opened
	The first record for a client connection, with the socket-endpoints of the connection.
	
	The format is::
	
		%s %d %s %s %s %d
		|  |  |  |  |  |
		|  |  |  |  |  +- File descriptor number
		|  |  |  |  +---- Local TCP port / 0 for UDS
		|  |  |  +------- Local IPv4/6 address / 0.0.0.0 for UDS
		|  |  +---------- Socket name (from -a argument)
		|  +------------- Remote TCP port / 0 for UDS
		+---------------- Remote IPv4/6 address / 0.0.0.0 for UDS
	


Storage - Where object is stored
	Type and name of the storage backend the object is stored in.
	
	The format is::
	
		%s %s
		|  |
		|  +- Name of storage backend
		+---- Type ("malloc", "file", "persistent" etc.)
	


TTL - TTL set on object
	A TTL record is emitted whenever the ttl, grace or keep values for an object is set as well as whether the object is  cacheable or not.
	
	The format is::
	
		%s %d %d %d %d [ %d %d %u %u ] %s
		|  |  |  |  |    |  |  |  |    |
		|  |  |  |  |    |  |  |  |    +- "cacheable" or "uncacheable"
		|  |  |  |  |    |  |  |  +------ Max-Age from Cache-Control header
		|  |  |  |  |    |  |  +--------- Expires header
		|  |  |  |  |    |  +------------ Date header
		|  |  |  |  |    +--------------- Age (incl Age: header value)
		|  |  |  |  +-------------------- Reference time for TTL
		|  |  |  +----------------------- Keep
		|  |  +-------------------------- Grace
		|  +----------------------------- TTL
		+-------------------------------- "RFC", "VCL" or "HFP"
	
	The four optional fields are only present in "RFC" headers.
	
	Examples::
	
		RFC 60 10 -1 1312966109 1312966109 1312966109 0 60 cacheable
		VCL 120 10 0 1312966111 uncacheable
		HFP 2 0 0 1312966113 uncacheable
	


Timestamp - Timing information
	Contains timing information for the Varnish worker threads.
	
	Time stamps are issued by Varnish on certain events, and show the absolute time of the event, the time spent since the start of the work unit, and the time spent since the last timestamp was logged. See the TIMESTAMPS section below for information about the individual time stamps.
	
	The format is::
	
		%s: %f %f %f
		|   |  |  |
		|   |  |  +- Time since last timestamp
		|   |  +---- Time since start of work unit
		|   +------- Absolute time of event
		+----------- Event label
	


VCL_Error - VCL execution error message
	Logs error messages generated during VCL execution.
	


VCL_Log - Log statement from VCL
	User generated log messages insert from VCL through std.log()

VCL_acl - VCL ACL check results
	Logs VCL ACL evaluation results.
	


VCL_call - VCL method called
	Logs the VCL method name when a VCL method is called.
	


VCL_return - VCL method return value
	Logs the VCL method terminating statement.
	


VCL_trace - VCL trace data
	Logs VCL execution trace data.
	
	The format is::
	
		%s %u %u.%u.%u
		|  |  |  |  |
		|  |  |  |  +- VCL program line position
		|  |  |  +---- VCL program line number
		|  |  +------- VCL program source index
		|  +---------- VCL trace point index
		+------------- VCL configname
	
	NB: This log record is masked by default.
	


VCL_use - VCL in use
	Records the name of the VCL being used.
	
	The format is::
	
		%s [ %s %s ]
		|    |  |
		|    |  +- Name of label used to find it
		|    +---- "via"
		+--------- Name of VCL put in use
	


VSL - VSL API warnings and error message
	Warnings and error messages generated by the VSL API while reading the shared memory log.
	


VfpAcct - Fetch filter accounting
	Contains name of VFP and statistics.
	
	The format is::
	
		%s %d %d
		|  |  |
		|  |  +- Total bytes produced
		|  +---- Number of calls made
		+------- Name of filter
	
	NB: This log record is masked by default.
	


Witness - Lock order witness records
	Diagnostic recording of locking order.


WorkThread - Logs thread start/stop events
	Logs worker thread creation and termination events.
	
	The format is::
	
		%p %s
		|  |
		|  +- [start|end]
		+---- Worker struct pointer
	
	NB: This log record is masked by default.
	


