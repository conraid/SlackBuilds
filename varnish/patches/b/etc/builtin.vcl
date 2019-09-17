# This is the VCL configuration Varnish will automatically append to your VCL
# file during compilation/loading. See the vcl(7) man page for details on syntax
# and semantics.
# New users is recommended to use the example.vcl file as a starting point.
# 
# sub vcl_recv {
#     if (req.http.host) {
#         set req.http.host = req.http.host.lower();
#     }
#     if (req.method == "PRI") {
#         /* This will never happen in properly formed traffic (see: RFC7540) */
#         return (synth(405));
#     }
#     if (!req.http.host &&
#       req.esi_level == 0 &&
#       req.proto ~ "^(?i)HTTP/1.1") {
#         /* In HTTP/1.1, Host is required. */
#         return (synth(400));
#     }
#     if (req.method != "GET" &&
#       req.method != "HEAD" &&
#       req.method != "PUT" &&
#       req.method != "POST" &&
#       req.method != "TRACE" &&
#       req.method != "OPTIONS" &&
#       req.method != "DELETE" &&
#       req.method != "PATCH") {
#         /* Non-RFC2616 or CONNECT which is weird. */
#         return (pipe);
#     }
# 
#     if (req.method != "GET" && req.method != "HEAD") {
#         /* We only deal with GET and HEAD by default */
#         return (pass);
#     }
#     if (req.http.Authorization || req.http.Cookie) {
#         /* Not cacheable by default */
#         return (pass);
#     }
#     return (hash);
# }
# 
# sub vcl_pipe {
#     # By default Connection: close is set on all piped requests, to stop
#     # connection reuse from sending future requests directly to the
#     # (potentially) wrong backend. If you do want this to happen, you can undo
#     # it here.
#     # unset bereq.http.connection;
#     return (pipe);
# }
# 
# sub vcl_pass {
#     return (fetch);
# }
# 
# sub vcl_hash {
#     hash_data(req.url);
#     if (req.http.host) {
#         hash_data(req.http.host);
#     } else {
#         hash_data(server.ip);
#     }
#     return (lookup);
# }
# 
# sub vcl_purge {
#     return (synth(200, "Purged"));
# }
# 
# sub vcl_hit {
#     return (deliver);
# }
# 
# sub vcl_miss {
#     return (fetch);
# }
# 
# sub vcl_deliver {
#     return (deliver);
# }
# 
# /*
#  * We can come here "invisibly" with the following errors: 500 & 503
#  */
# sub vcl_synth {
#     set resp.http.Content-Type = "text/html; charset=utf-8";
#     set resp.http.Retry-After = "5";
#     set resp.body = {"<!DOCTYPE html>
# <html>
#   <head>
#     <title>"} + resp.status + " " + resp.reason + {"</title>
#   </head>
#   <body>
#     <h1>Error "} + resp.status + " " + resp.reason + {"</h1>
#     <p>"} + resp.reason + {"</p>
#     <h3>Guru Meditation:</h3>
#     <p>XID: "} + req.xid + {"</p>
#     <hr>
#     <p>Varnish cache server</p>
#   </body>
# </html>
# "};
#     return (deliver);
# }
# 
# #######################################################################
# # Backend Fetch
# 
# sub vcl_backend_fetch {
#     if (bereq.method == "GET") {
#         unset bereq.body;
#     }
#     return (fetch);
# }
# 
# sub vcl_backend_response {
#     if (bereq.uncacheable) {
#         return (deliver);
#     } else if (beresp.ttl <= 0s ||
#       beresp.http.Set-Cookie ||
#       beresp.http.Surrogate-control ~ "(?i)no-store" ||
#       (!beresp.http.Surrogate-Control &&
#         beresp.http.Cache-Control ~ "(?i:no-cache|no-store|private)") ||
#       beresp.http.Vary == "*") {
#         # Mark as "Hit-For-Miss" for the next 2 minutes
#         set beresp.ttl = 120s;
#         set beresp.uncacheable = true;
#     }
#     return (deliver);
# }
# 
# sub vcl_backend_error {
#     set beresp.http.Content-Type = "text/html; charset=utf-8";
#     set beresp.http.Retry-After = "5";
#     set beresp.body = {"<!DOCTYPE html>
# <html>
#   <head>
#     <title>"} + beresp.status + " " + beresp.reason + {"</title>
#   </head>
#   <body>
#     <h1>Error "} + beresp.status + " " + beresp.reason + {"</h1>
#     <p>"} + beresp.reason + {"</p>
#     <h3>Guru Meditation:</h3>
#     <p>XID: "} + bereq.xid + {"</p>
#     <hr>
#     <p>Varnish cache server</p>
#   </body>
# </html>
# "};
#     return (deliver);
# }
# 
# #######################################################################
# # Housekeeping
# 
# sub vcl_init {
#     return (ok);
# }
# 
# sub vcl_fini {
#     return (ok);
# }
