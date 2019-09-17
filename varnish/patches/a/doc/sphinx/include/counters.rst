..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: main

MAIN – Main counters
====================

``summs`` – `counter` - debug

	stat summ operations

	Number of times per-thread statistics were summed into the
	global counters.

``uptime`` – `counter` - info

	Child process uptime

	How long the child process has been running.

``sess_conn`` – `counter` - info

	Sessions accepted

	Count of sessions successfully accepted

``sess_drop`` – `counter` - info

	Sessions dropped

	Count of sessions silently dropped due to lack of worker thread.

``sess_fail`` – `counter` - info

	Session accept failures

	Count of failures to accept TCP connection.

	This counter is the sum of the sess_fail_* counters, which
	give more detailed information.

``sess_fail_econnaborted`` – `counter` - info

	Session accept failures: connection aborted

	Detailed reason for sess_fail: Connection aborted by the
	client, usually harmless.

``sess_fail_eintr`` – `counter` - info

	Session accept failures: interrupted system call

	Detailed reason for sess_fail: The accept() call was
	interrupted, usually harmless

``sess_fail_emfile`` – `counter` - info

	Session accept failures: too many open files

	Detailed reason for sess_fail: No file descriptor was
	available. Consider raising RLIMIT_NOFILE (see ulimit -n).

``sess_fail_ebadf`` – `counter` - info

	Session accept failures: bad file descriptor

	Detailed reason for sess_fail: The listen socket file
	descriptor was invalid. Should never happen.

``sess_fail_enomem`` – `counter` - info

	Session accept failures: not enough memory

	Detailed reason for sess_fail: Most likely insufficient
	socket buffer memory. Should never happen

``sess_fail_other`` – `counter` - info

	Session accept failures: other

	Detailed reason for sess_fail: neither of the above, see
	SessError log (varnishlog -g raw -i SessError).

``client_req_400`` – `counter` - info

	Client requests received, subject to 400 errors

	400 means we couldn't make sense of the request, it was malformed
	in some drastic way.

``client_req_417`` – `counter` - info

	Client requests received, subject to 417 errors

	417 means that something went wrong with an Expect: header.

``client_req`` – `counter` - info

	Good client requests received

	The count of parseable client requests seen.

``cache_hit`` – `counter` - info

	Cache hits

	Count of cache hits.  A cache hit indicates that an object has been
	delivered to a client without fetching it from a backend server.

``cache_hit_grace`` – `counter` - info

	Cache grace hits

	Count of cache hits with grace. A cache hit with grace is a cache
	hit where the object is expired. Note that such hits are also
	included in the cache_hit counter.

``cache_hitpass`` – `counter` - info

	Cache hits for pass.

	Count of hits for pass. A cache hit for pass indicates that Varnish
	is going to pass the request to the backend and this decision has
	been cached in it self. This counts how many times the cached
	decision is being used.

``cache_hitmiss`` – `counter` - info

	Cache hits for miss.

	Count of hits for miss. A cache hit for miss indicates that Varnish
	is going to proceed as for a cache miss without request coalescing,
	and this decision has been cached. This counts how many times the
	cached decision is being used.

``cache_miss`` – `counter` - info

	Cache misses

	Count of misses. A cache miss indicates the object was fetched from
	the backend before delivering it to the client.

``backend_conn`` – `counter` - info

	Backend conn. success

	How many backend connections have successfully been established.

``backend_unhealthy`` – `counter` - info

	Backend conn. not attempted


``backend_busy`` – `counter` - info

	Backend conn. too many


``backend_fail`` – `counter` - info

	Backend conn. failures


``backend_reuse`` – `counter` - info

	Backend conn. reuses

	Count of backend connection reuses. This counter is increased
	whenever we reuse a recycled connection.

``backend_recycle`` – `counter` - info

	Backend conn. recycles

	Count of backend connection recycles. This counter is increased
	whenever we have a keep-alive connection that is put back into the
	pool of connections. It has not yet been used, but it might be,
	unless the backend closes it.

``backend_retry`` – `counter` - info

	Backend conn. retry


``fetch_head`` – `counter` - info

	Fetch no body (HEAD)

	beresp with no body because the request is HEAD.

``fetch_length`` – `counter` - info

	Fetch with Length

	beresp.body with Content-Length.

``fetch_chunked`` – `counter` - info

	Fetch chunked

	beresp.body with Chunked.

``fetch_eof`` – `counter` - info

	Fetch EOF

	beresp.body with EOF.

``fetch_bad`` – `counter` - info

	Fetch bad T-E

	beresp.body length/fetch could not be determined.

``fetch_none`` – `counter` - info

	Fetch no body

	beresp.body empty

``fetch_1xx`` – `counter` - info

	Fetch no body (1xx)

	beresp with no body because of 1XX response.

``fetch_204`` – `counter` - info

	Fetch no body (204)

	beresp with no body because of 204 response.

``fetch_304`` – `counter` - info

	Fetch no body (304)

	beresp with no body because of 304 response.

``fetch_failed`` – `counter` - info

	Fetch failed (all causes)

	beresp fetch failed.

``fetch_no_thread`` – `counter` - info

	Fetch failed (no thread)

	beresp fetch failed, no thread available.

``pools`` – `gauge` - info

	Number of thread pools

	Number of thread pools. See also parameter thread_pools. NB: Presently
	pools cannot be removed once created.

``threads`` – `gauge` - info

	Total number of threads

	Number of threads in all pools. See also parameters thread_pools,
	thread_pool_min and thread_pool_max.

``threads_limited`` – `counter` - info

	Threads hit max

	Number of times more threads were needed, but limit was reached in
	a thread pool. See also parameter thread_pool_max.

``threads_created`` – `counter` - info

	Threads created

	Total number of threads created in all pools.

``threads_destroyed`` – `counter` - info

	Threads destroyed

	Total number of threads destroyed in all pools.

``threads_failed`` – `counter` - info

	Thread creation failed

	Number of times creating a thread failed. See VSL::Debug for
	diagnostics. See also parameter thread_fail_delay.

``thread_queue_len`` – `gauge` - info

	Length of session queue

	Length of session queue waiting for threads. NB: Only updates once
	per second. See also parameter thread_queue_limit.

``busy_sleep`` – `counter` - info

	Number of requests sent to sleep on busy objhdr

	Number of requests sent to sleep without a worker thread because
	they found a busy object.

``busy_wakeup`` – `counter` - info

	Number of requests woken after sleep on busy objhdr

	Number of requests taken off the busy object sleep list and rescheduled.

``busy_killed`` – `counter` - info

	Number of requests killed after sleep on busy objhdr

	Number of requests killed from the busy object sleep list due to
	lack of resources.

``sess_queued`` – `counter` - info

	Sessions queued for thread

	Number of times session was queued waiting for a thread. See also
	parameter thread_queue_limit.

``sess_dropped`` – `counter` - info

	Sessions dropped for thread

	Number of times an HTTP/1 session was dropped because the queue was
	too long already. See also parameter thread_queue_limit.

``req_dropped`` – `counter` - info

	Requests dropped

	Number of times an HTTP/2 stream was refused because the queue was
	too long already. See also parameter thread_queue_limit.

``n_object`` – `gauge` - info

	object structs made

	Approximate number of HTTP objects (headers + body, if present) in
	the cache.

``n_vampireobject`` – `gauge` - diag

	unresurrected objects

	Number of unresurrected objects

``n_objectcore`` – `gauge` - info

	objectcore structs made

	Approximate number of object metadata elements in the cache. Each
	object needs an objectcore, extra objectcores are for hit-for-miss,
	hit-for-pass and busy objects.

``n_objecthead`` – `gauge` - info

	objecthead structs made

	Approximate number of different hash entries in the cache.

``n_backend`` – `gauge` - info

	Number of backends

	Number of backends known to us.

``n_expired`` – `counter` - info

	Number of expired objects

	Number of objects that expired from cache because of old age.

``n_lru_nuked`` – `counter` - info

	Number of LRU nuked objects

	How many objects have been forcefully evicted from storage to make
	room for a new object.

``n_lru_moved`` – `counter` - diag

	Number of LRU moved objects

	Number of move operations done on the LRU list.

``n_lru_limited`` – `counter` - info

	Reached nuke_limit

	Number of times more storage space were needed, but limit was reached in
	a nuke_limit. See also parameter nuke_limit.

``losthdr`` – `counter` - info

	HTTP header overflows


``s_sess`` – `counter` - info

	Total sessions seen


``n_pipe`` – `gauge` - info

	Number of ongoing pipe sessions


``pipe_limited`` – `counter` - info

	Pipes hit pipe_sess_max

	Number of times more pipes were needed, but the limit was reached. See
	also parameter pipe_sess_max.


``s_pipe`` – `counter` - info

	Total pipe sessions seen


``s_pass`` – `counter` - info

	Total pass-ed requests seen


``s_fetch`` – `counter` - info

	Total backend fetches initiated


``s_synth`` – `counter` - info

	Total synthetic responses made


``s_req_hdrbytes`` – `counter` - info

	Request header bytes

	Total request header bytes received

``s_req_bodybytes`` – `counter` - info

	Request body bytes

	Total request body bytes received

``s_resp_hdrbytes`` – `counter` - info

	Response header bytes

	Total response header bytes transmitted

``s_resp_bodybytes`` – `counter` - info

	Response body bytes

	Total response body bytes transmitted

``s_pipe_hdrbytes`` – `counter` - info

	Pipe request header bytes

	Total request bytes received for piped sessions

``s_pipe_in`` – `counter` - info

	Piped bytes from client

	Total number of bytes forwarded from clients in pipe sessions

``s_pipe_out`` – `counter` - info

	Piped bytes to client

	Total number of bytes forwarded to clients in pipe sessions

``sess_closed`` – `counter` - info

	Session Closed

``sess_closed_err`` – `counter` - info

	Session Closed with error

	Total number of sessions closed with errors. See sc_* diag counters
	for detailed breakdown

``sess_readahead`` – `counter` - info

	Session Read Ahead

``sess_herd`` – `counter` - diag

	Session herd

	Number of times the timeout_linger triggered

``sc_rem_close`` – `counter` - diag

	Session OK  REM_CLOSE

	Number of session closes with REM_CLOSE (Client Closed)

``sc_req_close`` – `counter` - diag

	Session OK  REQ_CLOSE

	Number of session closes with REQ_CLOSE (Client requested close)

``sc_req_http10`` – `counter` - diag

	Session Err REQ_HTTP10

	Number of session closes with Error REQ_HTTP10 (Proto < HTTP/1.1)

``sc_rx_bad`` – `counter` - diag

	Session Err RX_BAD

	Number of session closes with Error RX_BAD (Received bad req/resp)

``sc_rx_body`` – `counter` - diag

	Session Err RX_BODY

	Number of session closes with Error RX_BODY (Failure receiving req.body)

``sc_rx_junk`` – `counter` - diag

	Session Err RX_JUNK

	Number of session closes with Error RX_JUNK (Received junk data)

``sc_rx_overflow`` – `counter` - diag

	Session Err RX_OVERFLOW

	Number of session closes with Error RX_OVERFLOW (Received buffer overflow)

``sc_rx_timeout`` – `counter` - diag

	Session Err RX_TIMEOUT

	Number of session closes with Error RX_TIMEOUT (Receive timeout)

``sc_tx_pipe`` – `counter` - diag

	Session OK  TX_PIPE

	Number of session closes with TX_PIPE (Piped transaction)

``sc_tx_error`` – `counter` - diag

	Session Err TX_ERROR

	Number of session closes with Error TX_ERROR (Error transaction)

``sc_tx_eof`` – `counter` - diag

	Session OK  TX_EOF

	Number of session closes with TX_EOF (EOF transmission)

``sc_resp_close`` – `counter` - diag

	Session OK  RESP_CLOSE

	Number of session closes with RESP_CLOSE (Backend/VCL requested close)

``sc_overload`` – `counter` - diag

	Session Err OVERLOAD

	Number of session closes with Error OVERLOAD (Out of some resource)

``sc_pipe_overflow`` – `counter` - diag

	Session Err PIPE_OVERFLOW

	Number of session closes with Error PIPE_OVERFLOW (Session pipe overflow)

``sc_range_short`` – `counter` - diag

	Session Err RANGE_SHORT

	Number of session closes with Error RANGE_SHORT (Insufficient data for range)

``sc_req_http20`` – `counter` - diag

	Session Err REQ_HTTP20

	Number of session closes with Error REQ_HTTP20 (HTTP2 not accepted)

``sc_vcl_failure`` – `counter` - diag

	Session Err VCL_FAILURE

	Number of session closes with Error VCL_FAILURE (VCL failure)

``client_resp_500`` – `counter` - diag

	Delivery failed due to insufficient workspace.

	Number of times we failed a response due to running out of
	workspace memory during delivery.

``ws_backend_overflow`` – `counter` - diag

	workspace_backend overflows

	Number of times we ran out of space in workspace_backend.

``ws_client_overflow`` – `counter` - diag

	workspace_client overflows

	Number of times we ran out of space in workspace_client.

``ws_thread_overflow`` – `counter` - diag

	workspace_thread overflows

	Number of times we ran out of space in workspace_thread.

``ws_session_overflow`` – `counter` - diag

	workspace_session overflows

	Number of times we ran out of space in workspace_session.

``shm_records`` – `counter` - diag

	SHM records


``shm_writes`` – `counter` - diag

	SHM writes


``shm_flushes`` – `counter` - diag

	SHM flushes due to overflow


``shm_cont`` – `counter` - diag

	SHM MTX contention


``shm_cycles`` – `counter` - diag

	SHM cycles through buffer


``backend_req`` – `counter` - info

	Backend requests made


``n_vcl`` – `gauge` - info

	Number of loaded VCLs in total


``n_vcl_avail`` – `gauge` - diag

	Number of VCLs available


``n_vcl_discard`` – `gauge` - diag

	Number of discarded VCLs


``vcl_fail`` – `counter` - info

	VCL failures

	Count of failures which prevented VCL from completing.

``bans`` – `gauge` - info

	Count of bans

	Number of all bans in system, including bans superseded by newer
	bans and bans already checked by the ban-lurker.

``bans_completed`` – `gauge` - diag

	Number of bans marked 'completed'

	Number of bans which are no longer active, either because they got
	checked by the ban-lurker or superseded by newer identical bans.

``bans_obj`` – `gauge` - diag

	Number of bans using obj.*

	Number of bans which use obj.* variables.  These bans can possibly
	be washed by the ban-lurker.

``bans_req`` – `gauge` - diag

	Number of bans using req.*

	Number of bans which use req.* variables.  These bans can not be
	washed by the ban-lurker.

``bans_added`` – `counter` - diag

	Bans added

	Counter of bans added to ban list.

``bans_deleted`` – `counter` - diag

	Bans deleted

	Counter of bans deleted from ban list.

``bans_tested`` – `counter` - diag

	Bans tested against objects (lookup)

	Count of how many bans and objects have been tested against each
	other during hash lookup.

``bans_obj_killed`` – `counter` - diag

	Objects killed by bans (lookup)

	Number of objects killed by bans during object lookup.

``bans_lurker_tested`` – `counter` - diag

	Bans tested against objects (lurker)

	Count of how many bans and objects have been tested against each
	other by the ban-lurker.

``bans_tests_tested`` – `counter` - diag

	Ban tests tested against objects (lookup)

	Count of how many tests and objects have been tested against each
	other during lookup. 'ban req.url == foo && req.http.host == bar'
	counts as one in 'bans_tested' and as two in 'bans_tests_tested'

``bans_lurker_tests_tested`` – `counter` - diag

	Ban tests tested against objects (lurker)

	Count of how many tests and objects have been tested against each
	other by the ban-lurker. 'ban req.url == foo && req.http.host ==
	bar' counts as one in 'bans_tested' and as two in 'bans_tests_tested'

``bans_lurker_obj_killed`` – `counter` - diag

	Objects killed by bans (lurker)

	Number of objects killed by the ban-lurker.

``bans_lurker_obj_killed_cutoff`` – `counter` - diag

	Objects killed by bans for cutoff (lurker)

	Number of objects killed by the ban-lurker to keep the number of
	bans below ban_cutoff.

``bans_dups`` – `counter` - diag

	Bans superseded by other bans

	Count of bans replaced by later identical bans.

``bans_lurker_contention`` – `counter` - diag

	Lurker gave way for lookup

	Number of times the ban-lurker had to wait for lookups.

``bans_persisted_bytes`` – `gauge` - diag

	Bytes used by the persisted ban lists

	Number of bytes used by the persisted ban lists.

``bans_persisted_fragmentation`` – `gauge` - diag

	Extra bytes in persisted ban lists due to fragmentation

	Number of extra bytes accumulated through dropped and completed
	bans in the persistent ban lists.

``n_purges`` – `counter` - info

	Number of purge operations executed


``n_obj_purged`` – `counter` - info

	Number of purged objects


``exp_mailed`` – `counter` - diag

	Number of objects mailed to expiry thread

	Number of objects mailed to expiry thread for handling.

``exp_received`` – `counter` - diag

	Number of objects received by expiry thread

	Number of objects received by expiry thread for handling.

``hcb_nolock`` – `counter` - debug

	HCB Lookups without lock


``hcb_lock`` – `counter` - debug

	HCB Lookups with lock


``hcb_insert`` – `counter` - debug

	HCB Inserts


``esi_errors`` – `counter` - diag

	ESI parse errors (unlock)


``esi_warnings`` – `counter` - diag

	ESI parse warnings (unlock)


``vmods`` – `gauge` - info

	Loaded VMODs


``n_gzip`` – `counter` - info

	Gzip operations


``n_gunzip`` – `counter` - info

	Gunzip operations


``n_test_gunzip`` – `counter` - info

	Test gunzip operations

	Those operations occur when Varnish receives a compressed object
	from a backend. They are done to verify the gzip stream while it's
	inserted in storage.

..
	varnish_vsc_end:: main
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: mgt

MGT – Management Process Counters
=================================

``uptime`` – `counter` - info

	Management process uptime

	Uptime in seconds of the management process

``child_start`` – `counter` - diag

	Child process started

	Number of times the child process has been started

``child_exit`` – `counter` - diag

	Child process normal exit

	Number of times the child process has been cleanly stopped

``child_stop`` – `counter` - diag

	Child process unexpected exit

	Number of times the child process has exited with an
	unexpected return code

``child_died`` – `counter` - diag

	Child process died (signal)

	Number of times the child process has died due to signals

``child_dump`` – `counter` - diag

	Child process core dumped

	Number of times the child process has produced core dumps

``child_panic`` – `counter` - diag

	Child process panic

	Number of times the management process has caught a child panic

..
	varnish_vsc_end:: mgt
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: mempool

MEMPOOL – Memory Pool Counters
==============================

``live`` – `gauge` - debug

	In use


``pool`` – `gauge` - debug

	In Pool


``sz_wanted`` – `gauge` - debug

	Size requested


``sz_actual`` – `gauge` - debug

	Size allocated


``allocs`` – `counter` - debug

	Allocations

``frees`` – `counter` - debug

	Frees

``recycle`` – `counter` - debug

	Recycled from pool


``timeout`` – `counter` - debug

	Timed out from pool


``toosmall`` – `counter` - debug

	Too small to recycle


``surplus`` – `counter` - debug

	Too many for pool


``randry`` – `counter` - debug

	Pool ran dry


..
	varnish_vsc_end:: mempool
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: sma

SMA – Malloc Stevedore Counters
===============================

``c_req`` – `counter` - info

	Allocator requests

	Number of times the storage has been asked to provide a storage segment.

``c_fail`` – `counter` - info

	Allocator failures

	Number of times the storage has failed to provide a storage segment.

``c_bytes`` – `counter` - info

	Bytes allocated

	Number of total bytes allocated by this storage.

``c_freed`` – `counter` - info

	Bytes freed

	Number of total bytes returned to this storage.

``g_alloc`` – `gauge` - info

	Allocations outstanding

	Number of storage allocations outstanding.

``g_bytes`` – `gauge` - info

	Bytes outstanding

	Number of bytes allocated from the storage.

``g_space`` – `gauge` - info

	Bytes available

	Number of bytes left in the storage.

..
	varnish_vsc_end:: sma
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: smu

SMU – Umem Stevedore Counters
=============================

``c_req`` – `counter` - info

	Allocator requests

	Number of times the storage has been asked to provide a storage segment.

``c_fail`` – `counter` - info

	Allocator failures

	Number of times the storage has failed to provide a storage segment.

``c_bytes`` – `counter` - info

	Bytes allocated

	Number of total bytes allocated by this storage.

``c_freed`` – `counter` - info

	Bytes freed

	Number of total bytes returned to this storage.

``g_alloc`` – `gauge` - info

	Allocations outstanding

	Number of storage allocations outstanding.

``g_bytes`` – `gauge` - info

	Bytes outstanding

	Number of bytes allocated from the storage.

``g_space`` – `gauge` - info

	Bytes available

	Number of bytes left in the storage.

..
	varnish_vsc_end:: smu
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: smf

SMF – File Stevedore Counters
=============================

``c_req`` – `counter` - info

	Allocator requests

	Number of times the storage has been asked to provide a storage segment.

``c_fail`` – `counter` - info

	Allocator failures

	Number of times the storage has failed to provide a storage segment.

``c_bytes`` – `counter` - info

	Bytes allocated

	Number of total bytes allocated by this storage.

``c_freed`` – `counter` - info

	Bytes freed

	Number of total bytes returned to this storage.

``g_alloc`` – `gauge` - info

	Allocations outstanding

	Number of storage allocations outstanding.

``g_bytes`` – `gauge` - info

	Bytes outstanding

	Number of bytes allocated from the storage.

``g_space`` – `gauge` - info

	Bytes available

	Number of bytes left in the storage.

``g_smf`` – `gauge` - info

	N struct smf


``g_smf_frag`` – `gauge` - info

	N small free smf


``g_smf_large`` – `gauge` - info

	N large free smf


..
	varnish_vsc_end:: smf
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: vbe

VBE – Backend Counters
======================

``happy`` – `bitmap` - info

	Happy health probes

``bereq_hdrbytes`` – `counter` - info

	Request header bytes

	Total backend request header bytes sent

``bereq_bodybytes`` – `counter` - info

	Request body bytes

	Total backend request body bytes sent

``beresp_hdrbytes`` – `counter` - info

	Response header bytes

	Total backend response header bytes received

``beresp_bodybytes`` – `counter` - info

	Response body bytes

	Total backend response body bytes received

``pipe_hdrbytes`` – `counter` - info

	Pipe request header bytes

	Total request bytes sent for piped sessions

``pipe_out`` – `counter` - info

	Piped bytes to backend

	Total number of bytes forwarded to backend in pipe sessions

``pipe_in`` – `counter` - info

	Piped bytes from backend

	Total number of bytes forwarded from backend in pipe sessions

``conn`` – `gauge` - info

	Concurrent connections to backend

``req`` – `counter` - info

	Backend requests sent

``unhealthy`` – `counter` - info

	Fetches not attempted due to backend being unhealthy

``busy`` – `counter` - info

	Fetches not attempted due to backend being busy

	Number of times the max_connections limit was reached

..
	=== Anything below is actually per VCP entry, but collected per
	=== backend for simplicity

``fail`` – `counter` - info

	Connections failed

	Counter of failed opens. Detailed reasons are given in the
	fail_* counters (DIAG level) and in the log under the FetchError tag.

	This counter is the sum of all detailed fail_* counters.

	All fail_* counters may be slightly inaccurate for efficiency.

``fail_eacces`` – `counter` - diag

	Connections failed with EACCES or EPERM

``fail_eaddrnotavail`` – `counter` - diag

	Connections failed with EADDRNOTAVAIL

``fail_econnrefused`` – `counter` - diag

	Connections failed with ECONNREFUSED

``fail_enetunreach`` – `counter` - diag

	Connections failed with ENETUNREACH

``fail_etimedout`` – `counter` - diag

	Connections failed ETIMEDOUT

``fail_other`` – `counter` - diag

	Connections failed for other reason

``helddown`` – `counter` - diag

	Connection opens not attempted

	Connections not attempted during the backend_local_error_holddown
	or backend_remote_error_holddown interval after a fundamental
	connection issue.

..
	varnish_vsc_end:: vbe
..
	This is *NOT* a RST file but the syntax has been chosen so
	that it may become an RST file at some later date.

..
	varnish_vsc_begin:: lck

LCK – Lock Counters
===================

	Counters which track the activity in the different classes
	of mutex-locks.

	The counts may be slightly wrong if there are more than one
	lock instantiated in each class (ie: .creat > 1)

``creat`` – `counter` - debug

	Created locks


``destroy`` – `counter` - debug

	Destroyed locks


``locks`` – `counter` - debug

	Lock Operations


``dbg_busy`` – `counter` - debug

	Contended lock operations

	If the ``lck`` debug bit is set: Lock operations which
	returned EBUSY on the first locking attempt.

	If the ``lck`` debug bit is unset, this counter will never be
	incremented even if lock operations are contended.

``dbg_try_fail`` – `counter` - debug

	Contended trylock operations

	If the ``lck`` debug bit is set: Trylock operations which
	returned EBUSY.

	If the ``lck`` debug bit is unset, this counter will never be
	incremented even if lock operations are contended.

..
	varnish_vsc_end:: lck

