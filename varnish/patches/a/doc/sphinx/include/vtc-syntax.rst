barrier
-------

NOTE: This command is available everywhere commands are given.

Barriers allows you to synchronize different threads to make sure events
occur in the right order. It's even possible to use them in VCL.

First, it's necessary to declare the barrier::

        barrier bNAME TYPE NUMBER [-cyclic]

With the arguments being:

bNAME
        this is the name of the barrier, used to identify it when you'll
        create sync points. It must start with 'b'.

TYPE
        it can be "cond" (mutex) or "sock" (socket) and sets internal
        behavior. If you don't need VCL synchronization, use cond.

NUMBER
        number of sync point needed to go through the barrier.

\-cyclic
        if present, the barrier will reset itself and be ready for another
        round once gotten through.

Then, to add a sync point::

        barrier bNAME sync

This will block the parent thread until the number of sync points for bNAME
reaches the NUMBER given in the barrier declaration.

If you wish to synchronize the VCL, you need to declare a "sock" barrier.
This will emit a macro definition named "bNAME_sock" that you can use in
VCL (after importing the debug vmod)::

        debug.barrier_sync("${bNAME_sock}");

This function returns 0 if everything went well and is the equivalent of
``barrier bNAME sync`` at the VTC top-level.



client/server
-------------

Client and server threads are fake HTTP entities used to test your Varnish
and VCL. They take any number of arguments, and the one that are not
recognized, assuming they don't start with '-', are treated as
specifications, laying out the actions to undertake::

        client cNAME [...]
        server sNAME [...]

Clients and server are identified by a string that's the first argument,
clients' names start with 'c' and servers' names start with 's'.

As the client and server commands share a good deal of arguments and
specification actions, they are grouped in this single section, specific
items will be explicitly marked as such.


Arguments
~~~~~~~~~

\-start
       Start the thread in background, processing the last given
       specification.

\-wait
       Block until the thread finishes.

\-run (client only)
       Equivalent to "-start -wait".

\-repeat NUMBER
       Instead of processing the specification only once, do it NUMBER times.

\-keepalive
       For repeat, do not open new connections but rather run all
       iterations in the same connection

\-break (server only)
       Stop the server.

\-listen STRING (server only)
       Dictate the listening socket for the server. STRING is of the form
       "IP PORT", or "/PATH/TO/SOCKET" for a Unix domain socket. In the
       latter case, the path must begin with '/', and the server must be
       able to create it.

\-connect STRING (client only)
       Indicate the server to connect to. STRING is also of the form
       "IP PORT", or "/PATH/TO/SOCKET". As with "server -listen", a
       Unix domain socket is recognized when STRING begins with a '/'.

\-dispatch (server only, s0 only)
       Normally, to keep things simple, server threads only handle one
       connection at a time, but the -dispatch switch allows to accept
       any number of connection and handle them following the given spec.

       However, -dispatch is only allowed for the server name "s0".

\-proxy1 STRING (client only)
       Use the PROXY protocol version 1 for this connection. STRING
       is of the form "CLIENTIP:PORT SERVERIP:PORT".

\-proxy2 STRING (client only)
       Use the PROXY protocol version 2 for this connection. STRING
       is of the form "CLIENTIP:PORT SERVERIP:PORT".


Macros and automatic behaviour
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To make things easier in the general case, clients will connect by default
to the first Varnish server declared and the -vcl+backend switch of the
``varnish`` command will add all the declared servers as backends.

Be careful though, servers will by default listen to the 127.0.0.1 IP and
will pick a random port, and publish 3 macros: sNAME_addr, sNAME_port and
sNAME_sock, but only once they are started.
For 'varnish -vcl+backend' to create the vcl with the correct values, the
server must be started first.


Specification
~~~~~~~~~~~~~

It's a string, either double-quoted "like this", but most of the time
enclosed in curly brackets, allowing multilining. Write a command per line in
it, empty line are ignored, and long line can be wrapped by using a
backslash. For example::

    client c1 {
        txreq -url /foo \
              -hdr "bar: baz"

        rxresp
    } -run


accept (server only)
	Close the current connection, if any, and accept a new one. Note
	that this new connection is HTTP/1.x.


chunked STRING
        Send STRING as chunked encoding.


chunkedlen NUMBER
        Do as ``chunked`` except that the string will be generated
        for you, with a length of NUMBER characters.


close (server only)
	Close the connection. Note that if operating in HTTP/2 mode no
	extra (GOAWAY) frame is sent, it's simply a TCP close.


expect STRING1 OP STRING2
        Test if "STRING1 OP STRING2" is true, and if not, fails the test.
        OP can be ==, <, <=, >, >= when STRING1 and STRING2 represent numbers
        in which case it's an order operator. If STRING1 and STRING2 are
        meant as strings OP is a matching operator, either == (exact match)
        or ~ (regex match).

        varnishtet will first try to resolve STRING1 and STRING2 by looking
        if they have special meanings, in which case, the resolved value is
        use for the test. Note that this value can be a string representing a
        number, allowing for tests such as::

                expect req.http.x-num > 2

        Here's the list of recognized strings, most should be obvious as they
        either match VCL logic, or the txreq/txresp options:

        - remote.ip
        - remote.port
        - remote.path
        - req.method
        - req.url
        - req.proto
        - resp.proto
        - resp.status
        - resp.reason
        - resp.chunklen
        - req.bodylen
        - req.body
        - resp.bodylen
        - resp.body
        - req.http.NAME
        - resp.http.NAME


expect_close
	Reads from the connection, expecting nothing to read but an EOF.


fatal|non_fatal
        Control whether a failure of this entity should stop the test.


gunzip
        Gunzip the body in place.


loop NUMBER STRING
        Process STRING as a specification, NUMBER times.


recv NUMBER
        Read NUMBER bytes from the connection.


rxchunk
        Receive an HTTP chunk.


rxpri (server only)
	Receive a preface. If valid set the server to HTTP/2, abort
	otherwise.


rxreq (server only)
        Receive and parse a request's headers and body.


rxreqbody (server only)
        Receive a request's body.


rxreqhdrs (server only)
        Receive and parse a request's headers (but not the body).


rxresp [-no_obj] (client only)
        Receive and parse a response's headers and body. If -no_obj is
        present, only get the headers.


rxrespbody (client only)
        Receive (part of) a response's body.

-max : max length of this receive, 0 for all


rxresphdrs (client only)
        Receive and parse a response's headers.


send STRING
        Push STRING on the connection.


send_n NUMBER STRING
        Write STRING on the socket NUMBER times.


send_urgent STRING
        Send string as TCP OOB urgent data. You will never need this.


sendhex STRING
        Send bytes as described by STRING. STRING should consist of hex pairs
        possibly separated by whitespace or newlines. For example:
        "0F EE a5    3df2".


settings -dectbl INT
	Force internal HTTP/2 settings to certain values. Currently only
	support setting the decoding table size.


shell
	Same as for the top-level shell.


stream
	HTTP/2 introduces the concept of streams, and these come with
	their own specification, and as it's quite big, have been moved
	to their own chapter.



timeout NUMBER
        Set the TCP timeout for this entity.


txpri (client only)
	Send an HTTP/2 preface ("PRI * HTTP/2.0\\r\\n\\r\\nSM\\r\\n\\r\\n")
	and set client to HTTP/2.


txreq|txresp [...]
        Send a minimal request or response, but overload it if necessary.

        txreq is client-specific and txresp is server-specific.

        The only thing different between a request and a response, apart
        from who can send them is that the first line (request line vs
        status line), so all the options are prety much the same.

        \-method STRING (txreq only)
                What method to use (default: "GET").

        \-req STRING (txreq only)
                Alias for -method.

        \-url STRING (txreq only)
                What location to use (default "/").

        \-proto STRING
                What protocol use in the status line.
                (default: "HTTP/1.1").

        \-status NUMBER (txresp only)
                What status code to return (default 200).

        \-reason STRING (txresp only)
                What message to put in the status line (default: "OK").

        These three switches can appear in any order but must come before the
        following ones.

        \-nohost
                Don't include a Host header in the request.

        \-nolen
                Don't include a Content-Length header.

        \-hdr STRING
                Add STRING as a header, it must follow this format:
                "name: value". It can be called multiple times.

        \-hdrlen STRING NUMBER
                Add STRING as a header with NUMBER bytes of content.

        You can then use the arguments related to the body:

        \-body STRING
                Input STRING as body.

        \-bodyfrom FILE
                Same as -body but content is read from FILE.

        \-bodylen NUMBER
                Generate and input a body that is NUMBER bytes-long.

        \-gziplevel NUMBER
		   Set the gzip level (call it before any of the other gzip
		   switches).

        \-gzipresidual NUMBER
                Add extra gzip bits. You should never need it.

        \-gzipbody STRING
                Zip STRING and send it as body.

        \-gziplen NUMBER
                Combine -body and -gzipbody: create a body of length NUMBER,
                zip it and send as body.


write_body STRING
	Write the body of a request or a response to a file. By using the
	shell command, higher-level checks on the body can be performed
	(eg. XML, JSON, ...) provided that such checks can be delegated
	to an external program.

delay
-----

NOTE: This command is available everywhere commands are given.

Sleep for the number of seconds specified in the argument. The number
can include a fractional part, e.g. 1.5.


err_shell
---------

NOTICE: err_shell is deprecated, use `shell -err -expect` instead.

This is very similar to the the ``shell`` command, except it takes a first
string as argument before the command::

        err_shell "foo" "echo foo"

err_shell expect the shell command to fail AND stdout to match the string,
failing the test case otherwise.

feature
-------

Test that the required feature(s) for a test are available, and skip
the test otherwise; or change the interpretation of the test, as
documented below. feature takes any number of arguments from this list:

SO_RCVTIMEO_WORKS
       The SO_RCVTIMEO socket option is working
64bit
       The environment is 64 bits
dns
       DNS lookups are working
topbuild
       The test has been started with '-i'
root
       The test has been invoked by the root user
user_varnish
       The varnish user is present
user_vcache
       The vcache user is present
group_varnish
       The varnish group is present
cmd <command-line>
       A command line that should execute with a zero exit status
ignore_unknown_macro
       Do not fail the test if a string of the form ${...} is not
       recognized as a macro.

persistent_storage
       Varnish was built with the deprecated persistent storage.

Be careful with ignore_unknown_macro, because it may cause a test with a
misspelled macro to fail silently. You should only need it if you must
run a test with strings of the form "${...}".

haproxy
-------

Define and interact with haproxy instances.

To define a haproxy server, you'll use this syntax::

	haproxy hNAME -conf-OK CONFIG
	haproxy hNAME -conf-BAD ERROR CONFIG
	haproxy hNAME [-D] [-W] [-arg STRING] [-conf[+vcl] STRING]

The first ``haproxy hNAME`` invocation will start the haproxy master
process in the background, waiting for the ``-start`` switch to actually
start the child.

Arguments:

hNAME
	   Identify the HAProxy server with a string, it must starts with 'h'.

\-conf-OK CONFIG
        Run haproxy in '-c' mode to check config is OK
	   stdout/stderr should contain 'Configuration file is valid'
	   The exit code should be 0.

\-conf-BAD ERROR CONFIG
        Run haproxy in '-c' mode to check config is BAD.
	   "ERROR" should be part of the diagnostics on stdout/stderr.
	   The exit code should be 1.

\-D
        Run HAproxy in daemon mode.  If not given '-d' mode used.

\-W
        Enable HAproxy in Worker mode.

\-arg STRING
        Pass an argument to haproxy, for example "-h simple_list".

\-cli STRING
        Specify the spec to be run by the command line interface (CLI).

\-conf STRING
        Specify the configuration to be loaded by this HAProxy instance.

\-conf+backend STRING
        Specify the configuration to be loaded by this HAProxy instance,
	   all server instances will be automatically appended

\-start
        Start this HAProxy instance.

\-wait
        Stop this HAProxy instance.

\-expectexit NUMBER
	   Expect haproxy to exit(3) with this value


haproxy CLI Specification
~~~~~~~~~~~~~~~~~~~~~~~~~

expect OP STRING
        Regex match the CLI reception buffer with STRING
        if OP is ~ or, on the contraty, if OP is !~ check that there is
        no regex match.

send STRING
        Push STRING on the CLI connection. STRING will be terminated by an
        end of line character (\n).

logexpect
---------

Reads the VSL and looks for records matching a given specification. It will
process records trying to match the first pattern, and when done, will
continue processing, trying to match the following pattern. If a pattern
isn't matched, the test will fail.

logexpect threads are declared this way::

        logexpect lNAME -v <id> [-g <grouping>] [-d 0|1] [-q query] \
                [vsl arguments] {
                        expect <skip> <vxid> <tag> <regex>
                        expect <skip> <vxid> <tag> <regex>
                        ...
                } [-start|-wait]

And once declared, you can start them, or wait on them::

        logexpect lNAME <-start|-wait>

With:

lNAME
        Name the logexpect thread, it must start with 'l'.

\-v id
        Specify the varnish instance to use (most of the time, id=v1).

\-g <session|request|vxid|raw
        Decide how records are grouped, see -g in ``man varnishlog`` for more
        information.

\-d <0|1>
        Start processing log records at the head of the log instead of the
        tail.

\-q query
        Filter records using a query expression, see ``man vsl-query`` for
        more information.
\-m
	   Also emit log records for misses (only for debugging)

\-start
        Start the logexpect thread in the background.

\-wait
        Wait for the logexpect thread to finish

VSL arguments (similar to the varnishlog options):

\-b|-c
        Process only backend/client records.

\-C
        Use caseless regex

\-i <taglist>
        Include tags

\-I <[taglist:]regex>
        Include by regex

\-T <seconds>
        Transaction end timeout

And the arguments of the specifications lines are:

skip: [uint|*]
        Max number of record to skip

vxid: [uint|*|=]
        vxid to match

tag:  [tagname|*|=]
        Tag to match against

regex:
        regular expression to match against (optional)

For skip, vxid and tag, '*' matches anything, '=' expects the value of the
previous matched record.

process
-------

Run a process with stdin+stdout on a pseudo-terminal and stderr on a pipe.

Output from the pseudo-terminal is copied verbatim to ${pNAME_out},
and the -log/-dump/-hexdump flags will also put it in the vtc-log.

The pseudo-terminal is not in ECHO mode, but if the programs run set
it to ECHO mode ("stty sane") any input sent to the process will also
appear in this stream because of the ECHO.

Output from the stderr-pipe is copied verbatim to ${pNAME_err}, and
is always included in the vtc_log.

	process pNAME SPEC [-log] [-dump] [-hexdump] [-expect-exit N]
		[-start] [-run]
		[-write STRING] [-writeln STRING]
		[-kill STRING] [-stop] [-wait] [-close]

pNAME
	Name of the process. It must start with 'p'.

SPEC
	The command(s) to run in this process.

\-hexdump
	Log output with vtc_hexdump(). Must be before -start/-run.

\-dump
	Log output with vtc_dump(). Must be before -start/-run.

\-log
	Log output with VLU/vtc_log(). Must be before -start/-run.

\-start
	Start the process.

\-expect-exit N
	Expect exit status N

\-wait
	Wait for the process to finish.

\-run
	Shorthand for -start -wait.

	In most cases, if you just want to start a process and wait for it
	to finish, you can use the ``shell`` command instead.
	The following commands are equivalent::

	    shell "do --something"

	    process p1 "do --something" -run

	However, you may use the the ``process`` variant to conveniently
	collect the standard input and output without dealing with shell
	redirections yourself. The ``shell`` command can also expect an
	expression from either output, consider using it if you only need
	to match one.

\-kill STRING
	Send a signal to the process. The argument can be either
	the string "TERM", "INT", or "KILL" for SIGTERM, SIGINT or SIGKILL
	signals, respectively, or a hyphen (-) followed by the signal
	number.

	If you need to use other signal names, you can use the ``kill``\(1)
	command directly::

	    shell "kill -USR1 ${pNAME_pid}"

	Note that SIGHUP usage is discouraged in test cases.

\-stop
	Shorthand for -kill TERM.

\-write STRING
	Write a string to the process' stdin.

\-writeln STRING
	Same as -write followed by a newline (\\n).

\-writehex HEXSTRING
	Same as -write but interpreted as hexadecimal bytes.

\-need-bytes [+]NUMBER
	Wait until at least NUMBER bytes have been received in total.
	If '+' is prefixed, NUMBER new bytes must be received.

\-expect-text LIN COL PAT
	Wait for PAT to appear at LIN,COL on the virtual screen.
	Lines and columns are numbered 1...N
	LIN==0 means "on any line"
	COL==0 means "anywhere on the line"

\-close
	Alias for "-kill HUP"

\-screen_dump
	Dump the virtual screen into vtc_log


setenv
------

Set or change an environment variable::

        setenv FOO "bar baz"

The above will set the environment variable $FOO to the value
provided. There is also an ``-ifunset`` argument which will only
set the value if the the environment variable does not already
exist::

       setenv -ifunset FOO quux

shell
-----

NOTE: This command is available everywhere commands are given.

Pass the string given as argument to a shell. If you have multiple
commands to run, you can use curly brackets to describe a multi-lines
script, eg::

        shell {
                echo begin
                cat /etc/fstab
                echo end
        }

By default a zero exit code is expected, otherwise the vtc will fail.

Notice that the commandstring is prefixed with "exec 2>&1;" to combine
stderr and stdout back to the test process.

Optional arguments:

\-err
	Expect non-zero exit code.

\-exit N
	Expect exit code N instead of zero.

\-expect STRING
	Expect string to be found in stdout+err.

\-match REGEXP
	Expect regexp to match the stdout+err output.

stream
------

(note: this section is at the top-level for easier navigation, but
it's part of the client/server specification)

Streams map roughly to a request in HTTP/2, a request is sent on
stream N, the response too, then the stream is discarded. The main
exception is the first stream, 0, that serves as coordinator.

Stream syntax follow the client/server one::

	stream ID [SPEC] [ACTION]

ID is the HTTP/2 stream number, while SPEC describes what will be
done in that stream.

Note that, when parsing a stream action, if the entity isn't operating
in HTTP/2 mode, these spec is ran before::

	txpri/rxpri # client/server
	stream 0 {
	    txsettings
	    rxsettings
	    txsettings -ack
	    rxsettings
	    expect settings.ack == true
	} -run

And HTTP/2 mode is then activated before parsing the specification.


Actions
~~~~~~~

\-start
	Run the specification in a thread, giving back control immediately.

\-wait
	Wait for the started thread to finish running the spec.

\-run
	equivalent to calling ``-start`` then ``-wait``.

Specification
~~~~~~~~~~~~~

The specification of a stream follows the exact same rules as one for a
client or a server.

txreq, txresp, txcont, txpush
.............................

These four commands are about sending headers. txreq and txresp
will send HEADER frames; txcont will send CONTINUATION frames; txpush
PUSH frames.
The only difference between txreq and txresp are the default headers
set by each of them.

\-noadd
	Do not add default headers. Useful to avoid duplicates when sending
	default headers using ``-hdr``, ``-idxHdr`` and ``-litIdxHdr``.

\-status INT (txresp)
	Set the :status pseudo-header.

\-url STRING (txreq, txpush)
	Set the :path pseudo-header.

\-method STRING (txreq, txpush)
	Set the :method pseudo-header.

\-req STRING (txreq, txpush)
	Alias for -method.

\-scheme STRING (txreq, txpush)
	Set the :scheme pseudo-header.

\-hdr STRING1 STRING2
	Insert a header, STRING1 being the name, and STRING2 the value.

\-idxHdr INT
	Insert an indexed header, using INT as index.

\-litIdxHdr inc|not|never INT huf|plain STRING
	Insert an literal, indexed header. The first argument specify if the
	header should be added to the table, shouldn't, or mustn't be
	compressed if/when retransmitted.

	INT is the idex of the header name to use.

	The third argument informs about the Huffman encoding: yes (huf) or
	no (plain).

	The last term is the literal value of the header.

\-litHdr inc|not|never huf|plain STRING1 huf|plain STRING2
	Insert a literal header, with the same first argument as
	``-litIdxHdr``.

	The second and third terms tell what the name of the header is and if
	it should be Huffman-encoded, while the last two do the same
	regarding the value.

\-body STRING (txreq, txresp)
	Specify a body, effectively putting STRING into a DATA frame after
	the HEADER frame is sent.

\-bodyfrom FILE (txreq, txresp)
	Same as ``-body`` but content is read from FILE.

\-bodylen INT (txreq, txresp)
	Do the same thing as ``-body`` but generate an string of INT length
	for you.

\-gzipbody STRING (txreq, txresp)
     Gzip STRING and send it as body.

\-gziplen NUMBER (txreq, txresp)
     Combine -body and -gzipbody: create a body of length NUMBER,
     gzip it and send as body.

\-nostrend (txreq, txresp)
	Don't set the END_STREAM flag automatically, making the peer expect
	a body after the headers.

\-nohdrend
	Don't set the END_HEADERS flag automatically, making the peer expect
	more HEADER frames.

\-dep INT (txreq, txresp)
	Tell the peer that this content depends on the stream with the INT
	id.

\-ex (txreq, txresp)
	Make the dependency exclusive (``-dep`` is still needed).

\-weight (txreq, txresp)
	Set the weight for the dependency.

\-promised INT (txpush)
	The id of the promised stream.

\-pad STRING / -padlen INT (txreq, txresp, txpush)
	Add string as padding to the frame, either the one you provided with
	\-pad, or one that is generated for you, of length INT is -padlen
	case.

txdata
......

By default, data frames are empty. The receiving end will know the whole body
has been delivered thanks to the END_STREAM flag set in the last DATA frame,
and txdata automatically set it.

\-data STRING
	Data to be embedded into the frame.

\-datalen INT
	Generate and INT-bytes long string to be sent in the frame.

\-pad STRING / -padlen INT
	Add string as padding to the frame, either the one you provided with
	\-pad, or one that is generated for you, of length INT is -padlen
	case.

\-nostrend
	Don't set the END_STREAM flag, allowing to send more data on this
	stream.

rxreq, rxresp
.............

These are two convenience functions to receive headers and body of an
incoming request or response. The only difference is that rxreq can only be
by a server, and rxresp by a client.


rxhdrs
......

``rxhdrs`` will expect one HEADER frame, then, depending on the arguments,
zero or more CONTINUATION frame.

\-all
	Keep waiting for CONTINUATION frames until END_HEADERS flag is seen.

\-some INT
	Retrieve INT - 1 CONTINUATION frames after the HEADER frame.


rxpush
......

This works like ``rxhdrs``, expecting a PUSH frame and then zero or more
CONTINUATION frames.

\-all
	Keep waiting for CONTINUATION frames until END_HEADERS flag is seen.

\-some INT
	Retrieve INT - 1 CONTINUATION frames after the PUSH frame.


rxdata
......

Receiving data is done using the ``rxdata`` keywords and will retrieve one
DATA frame, if you wish to receive more, you can use these two convenience
arguments:

\-all
	keep waiting for DATA frame until one sets the END_STREAM flag

\-some INT
	retrieve INT DATA frames.



Receive a frame, any frame.

sendhex
.......

Push bytes directly on the wire. sendhex takes exactly one argument: a string
describing the bytes, in hex notation, with possible whitespaces between
them. Here's an example::

	sendhex "00 00 08 00 0900	8d"

rxgoaway
........

Receive a GOAWAY frame.

txgoaway
........

Possible options include:

\-err STRING|INT
	set the error code to explain the termination. The second argument
	can be a integer or the string version of the error code as found
	in rfc7540#7.

\-laststream INT
	the id of the "highest-numbered stream identifier for which the
	sender of the GOAWAY frame might have taken some action on or might
	yet take action on".

\-debug
	specify the debug data, if any to append to the frame.

gunzip
......

Same as the ``gunzip`` command for HTTP/1.

rxping
......

Receive a PING frame.

txping
......

Send PING frame.

\-data STRING
	specify the payload of the frame, with STRING being an 8-char string.

\-ack
	set the ACK flag.

rxprio
......

Receive a PRIORITY frame.

txprio
......

Send a PRIORITY frame

\-stream INT
	indicate the id of the stream the sender stream depends on.

\-ex
	the dependency should be made exclusive (only this streams depends on
	the parent stream).

\-weight INT
	an 8-bits integer is used to balance priority between streams
	depending on the same streams.

rxrst
.....

Receive a RST_STREAM frame.

txrst
.....

Send a RST_STREAM frame. By default, txrst will send a 0 error code
(NO_ERROR).

\-err STRING|INT
	Sets the error code to be sent. The argument can be an integer or a
	string describing the error, such as NO_ERROR, or CANCEL (see
	rfc7540#11.4 for more strings).

rxsettings
..........

Receive a SETTINGS frame.

txsettings
..........

SETTINGS frames must be acknowledge, arguments are as follow (most of them
are from  rfc7540#6.5.2):

\-hdrtbl INT
	headers table size

\-push BOOL
	whether push frames are accepted or not

\-maxstreams INT
	maximum concurrent streams allowed

\-winsize INT
	sender's initial window size

\-framesize INT
	largest frame size authorized

\-hdrsize INT
	maximum size of the header list authorized

\-ack
	set the ack bit

rxwinup
.......

Receive a WINDOW_UPDATE frame.

txwinup
.......

Transmit a WINDOW_UPDATE frame, increasing the amount of credit of the
connection (from stream 0) or of the stream (any other stream).

\-size INT
	give INT credits to the peer.


write_body STRING
	Same as the ``write_body`` command for HTTP/1.

expect
......

expect in stream works as it does in client or server, except that the
elements compared will be different.

Most of these elements will be frame specific, meaning that the last frame
received on that stream must of the correct type.

Here the list of keywords you can look at.

syslog
------

Define and interact with syslog instances (for use with haproxy)

To define a syslog server, you'll use this syntax::

    syslog SNAME

Arguments:

SNAME
    Identify the syslog server with a string which must start with 'S'.

\-level STRING
        Set the default syslog priority level used by any subsequent "recv"
        command.
        Any syslog dgram with a different level will be skipped by
        "recv" command. This default level value may be superseded
        by "recv" command if supplied as first argument: "recv <level>".

\-start
        Start the syslog server thread in the background.

\-repeat
        Instead of processing the specification only once, do it
	   NUMBER times.

\-bind
        Bind the syslog socket to a local address.

\-wait
        Wait for that thread to terminate.

\-stop
        Stop the syslog server thread.

varnish
-------

Define and interact with varnish instances.

To define a Varnish server, you'll use this syntax::

	varnish vNAME [-arg STRING] [-vcl STRING] [-vcl+backend STRING]
		[-errvcl STRING STRING] [-jail STRING] [-proto PROXY]

The first ``varnish vNAME`` invocation will start the varnishd master
process in the background, waiting for the ``-start`` switch to actually
start the child.

Types used in the description below:

PATTERN
        is a 'glob' style pattern (ie: fnmatch(3)) as used in shell filename
        expansion.

Arguments:

vNAME
	   Identify the Varnish server with a string, it must starts with 'v'.

\-arg STRING
        Pass an argument to varnishd, for example "-h simple_list".

\-vcl STRING
        Specify the VCL to load on this Varnish instance. You'll probably
        want to use multi-lines strings for this ({...}).

\-vcl+backend STRING
        Do the exact same thing as -vcl, but adds the definition block of
        known backends (ie. already defined).

\-errvcl STRING1 STRING2
        Load STRING2 as VCL, expecting it to fail, and Varnish to send an
        error string matching STRING2

\-jail STRING
        Look at ``man varnishd`` (-j) for more information.

\-proto PROXY
        Have Varnish use the proxy protocol. Note that PROXY here is the
        actual string.

You can decide to start the Varnish instance and/or wait for several events::

        varnish vNAME [-start] [-wait] [-wait-running] [-wait-stopped]

\-start
        Start the child process.

\-stop
        Stop the child process.

\-syntax
        Set the VCL syntax level for this command (default: 4.1)

\-wait
        Wait for that instance to terminate.

\-wait-running
        Wait for the Varnish child process to be started.

\-wait-stopped
        Wait for the Varnish child process to stop.

\-cleanup
        Once Varnish is stopped, clean everything after it. This is only used
        in very few tests and you should never need it.

Once Varnish is started, you can talk to it (as you would through
``varnishadm``) with these additional switches::

        varnish vNAME [-cli STRING] [-cliok STRING] [-clierr STRING]
                      [-clijson STRING] [-expect STRING OP NUMBER]

\-cli STRING|-cliok STRING|-clierr STATUS STRING|-cliexpect REGEXP STRING
        All four of these will send STRING to the CLI, the only difference
        is what they expect the result to be. -cli doesn't expect
        anything, -cliok expects 200, -clierr expects STATUS, and
        -cliexpect expects the REGEXP to match the returned response.

\-clijson STRING
	   Send STRING to the CLI, expect success (CLIS_OK/200) and check
	   that the response is parsable JSON.

\-expect PATTERN OP NUMBER
        Look into the VSM and make sure the first VSC counter identified by
        PATTERN has a correct value. OP can be ==, >, >=, <, <=. For
        example::

                varnish v1 -expect SM?.s1.g_space > 1000000
\-expectexit NUMBER
	   Expect varnishd to exit(3) with this value

\-vsc PATTERN
        Dump VSC counters matching PATTERN.

\-vsl_catchup
        Wait until the logging thread has idled to make sure that all
        the generated log is flushed

varnishtest
-----------

Alternate name for 'vtest', see above.


vtest
-----

This should be the first command in your vtc as it will identify the test
case with a short yet descriptive sentence. It takes exactly one argument, a
string, eg::

        vtest "Check that vtest is actually a valid command"

It will also print that string in the log.

