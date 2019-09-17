..
.. NB:  This file is machine generated, DO NOT EDIT!
..
.. Edit vmod.vcc and run make instead
..


:tocdepth: 1


.. _vmod_vtc(3):

=========================================
VMOD vtc - Utility module for varnishtest
=========================================

SYNOPSIS
========

.. parsed-literal::

  import vtc [as name] [from "path"]
  
  :ref:`vtc.barrier_sync()`
   
  :ref:`vtc.no_backend()`
   
  :ref:`vtc.no_stevedore()`
   
  :ref:`vtc.no_ip()`
   
  :ref:`vtc.panic()`
   
  :ref:`vtc.sleep()`
   
  :ref:`vtc.workspace_alloc()`
   
  :ref:`vtc.workspace_free()`
   
  :ref:`vtc.workspace_snapshot()`
   
  :ref:`vtc.workspace_reset()`
   
  :ref:`vtc.workspace_overflowed()`
   
  :ref:`vtc.workspace_overflow()`
   
  :ref:`vtc.workspace_dump()`
   
  :ref:`vtc.typesize()`
   
DESCRIPTION
===========

The goal for this VMOD is to provide VCL users and VMOD authors means to
test corner cases or reach certain conditions with varnishtest.

.. _vtc.barrier_sync():

VOID barrier_sync(STRING addr, DURATION timeout=0)
--------------------------------------------------

When writing test cases, the most common pattern is to start a mock server
instance, a Varnish instance, and spin up a mock client. Those entities run
asynchronously, and others exist like background processes (``process``) or
log readers (``logexpect``). While you can synchronize with individual
entities and wait for their completion, you must use a barrier if you need
to synchronize two or more entities, or wait until a certain point instead
of completion.

Not only is it possible to synchronize between test entities, with the
``barrier_sync`` function you can even synchronize VCL code::

    sub vcl_recv {
	# wait for some barrier b1 to complete
	vtc.barrier_sync("${b1_sock}");
    }

If the function fails to synchronize with the barrier for some reason, or if
it reaches the optional timeout, it fails the VCL transaction.

MISCELLANEOUS
=============

.. _vtc.no_backend():

BACKEND no_backend()
--------------------

Fails at backend selection.

.. _vtc.no_stevedore():

STEVEDORE no_stevedore()
------------------------

Fails at storage selection.

.. _vtc.no_ip():

IP no_ip()
----------

Returns a null IP address, not even a bogo_ip.

.. _vtc.panic():

VOID panic(STRING)
------------------

It can be useful to crash the child process in order to test the robustness
of a VMOD.

.. _vtc.sleep():

VOID sleep(DURATION)
--------------------

Block the current worker thread.

WORKSPACES
==========

It can be useful to put a workspace in a given state when testing corner
cases like resource exhaustion for a transaction, especially for VMOD
development. All functions available allow to pick which workspace you
need to tamper with, available values are ``client``, ``backend``, ``session``
and ``thread``.

.. _vtc.workspace_alloc():

VOID workspace_alloc(ENUM, INT size)
------------------------------------

::

   VOID workspace_alloc(
      ENUM {client, backend, session, thread},
      INT size
   )

Allocate and zero out memory from a workspace. A negative size will allocate
as much as needed to leave that many bytes free. The actual allocation size
may be higher to comply with memory alignment requirements of the CPU
architecture. A failed allocation fails the transaction.

.. _vtc.workspace_free():

INT workspace_free(ENUM {client, backend, session, thread})
-----------------------------------------------------------

Find how much unallocated space there is left in a workspace.

.. _vtc.workspace_snapshot():

VOID workspace_snapshot(ENUM)
-----------------------------

::

   VOID workspace_snapshot(ENUM {client, backend, session, thread})

Snapshot a workspace. Only one snapshot may be active at a time and
each VCL can save only one snapshot, so concurrent tasks requiring
snapshots are not supported.

.. _vtc.workspace_reset():

VOID workspace_reset(ENUM)
--------------------------

::

   VOID workspace_reset(ENUM {client, backend, session, thread})

Reset to the previous snapshot of a workspace, it must be the same workspace
too.

.. _vtc.workspace_overflowed():

BOOL workspace_overflowed(ENUM)
-------------------------------

::

   BOOL workspace_overflowed(ENUM {client, backend, session, thread})

Find whether the workspace overflow mark is set or not.

.. _vtc.workspace_overflow():

VOID workspace_overflow(ENUM)
-----------------------------

::

   VOID workspace_overflow(ENUM {client, backend, session, thread})

Mark a workspace as overflowed.

.. _vtc.workspace_dump():

BLOB workspace_dump(ENUM, ENUM, BYTES off, BYTES len)
-----------------------------------------------------

::

   BLOB workspace_dump(
      ENUM {client, backend, session, thread},
      ENUM {s, f, r},
      BYTES off=0,
      BYTES len=64
   )

Return data from a workspace's ``s``, ``f``, or ``r`` pointer as a
blob. Data is copied onto the primary workspace to avoid it being
subsequently overwritten.

The maximum *len* is 1KB.

.. _vtc.typesize():

INT typesize(STRING)
--------------------

Returns the size in bytes of a collection of C-datatypes:

* ``'p'``: pointer
* ``'i'``: ``int``
* ``'d'``: ``double``
* ``'f'``: ``float``
* ``'l'``: ``long``
* ``'s'``: ``short``
* ``'z'``: ``size_t``
* ``'o'``: ``off_t``
* ``'j'``: ``intmax_t``

This can be useful for VMOD authors in conjunction with workspace operations.

SEE ALSO
========

* :ref:`vtc(7)`
* :ref:`vcl(7)`

COPYRIGHT
=========

::

  Copyright (c) 2017 Varnish Software AS
  All rights reserved.
 
  Author: Dridi Boukelmoune <dridi.boukelmoune@gmail.com>
 
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
 
  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.
