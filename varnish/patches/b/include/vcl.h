/*
 * NB:  This file is machine generated, DO NOT EDIT!
 *
 * Edit and run lib/libvcc/generate.py instead.
 */


#ifdef VCL_H_INCLUDED
#  error "vcl.h included multiple times"
#endif
#define VCL_H_INCLUDED

#ifndef VRT_H_INCLUDED
#  error "include vrt.h before vcl.h"
#endif

/* VCL Methods */
#define VCL_MET_RECV			(1U << 1)
#define VCL_MET_PIPE			(1U << 2)
#define VCL_MET_PASS			(1U << 3)
#define VCL_MET_HASH			(1U << 4)
#define VCL_MET_PURGE			(1U << 5)
#define VCL_MET_MISS			(1U << 6)
#define VCL_MET_HIT			(1U << 7)
#define VCL_MET_DELIVER			(1U << 8)
#define VCL_MET_SYNTH			(1U << 9)
#define VCL_MET_BACKEND_FETCH		(1U << 10)
#define VCL_MET_BACKEND_RESPONSE	(1U << 11)
#define VCL_MET_BACKEND_ERROR		(1U << 12)
#define VCL_MET_INIT			(1U << 13)
#define VCL_MET_FINI			(1U << 14)

#define VCL_MET_MAX			15

#define VCL_MET_MASK			0x7fff

#define VCL_MET_TASK_B			( VCL_MET_BACKEND_FETCH | \
					  VCL_MET_BACKEND_RESPONSE | \
					  VCL_MET_BACKEND_ERROR )
#define VCL_MET_TASK_C			( VCL_MET_RECV | \
					  VCL_MET_PIPE | \
					  VCL_MET_PASS | \
					  VCL_MET_HASH | \
					  VCL_MET_PURGE | \
					  VCL_MET_MISS | \
					  VCL_MET_HIT | \
					  VCL_MET_DELIVER | \
					  VCL_MET_SYNTH )
#define VCL_MET_TASK_H			( VCL_MET_INIT | \
					  VCL_MET_FINI )

/* VCL Returns */
#define VCL_RET_ABANDON			1
#define VCL_RET_DELIVER			2
#define VCL_RET_ERROR			3
#define VCL_RET_FAIL			4
#define VCL_RET_FETCH			5
#define VCL_RET_HASH			6
#define VCL_RET_LOOKUP			7
#define VCL_RET_OK			8
#define VCL_RET_PASS			9
#define VCL_RET_PIPE			10
#define VCL_RET_PURGE			11
#define VCL_RET_RESTART			12
#define VCL_RET_RETRY			13
#define VCL_RET_SYNTH			14
#define VCL_RET_VCL			15

#define VCL_RET_MAX			16

/* VCL Types */
extern const struct vrt_type VCL_TYPE_ACL[1];
extern const struct vrt_type VCL_TYPE_BACKEND[1];
extern const struct vrt_type VCL_TYPE_BLOB[1];
extern const struct vrt_type VCL_TYPE_BODY[1];
extern const struct vrt_type VCL_TYPE_BOOL[1];
extern const struct vrt_type VCL_TYPE_BYTES[1];
extern const struct vrt_type VCL_TYPE_DURATION[1];
extern const struct vrt_type VCL_TYPE_ENUM[1];
extern const struct vrt_type VCL_TYPE_HEADER[1];
extern const struct vrt_type VCL_TYPE_HTTP[1];
extern const struct vrt_type VCL_TYPE_INSTANCE[1];
extern const struct vrt_type VCL_TYPE_INT[1];
extern const struct vrt_type VCL_TYPE_IP[1];
extern const struct vrt_type VCL_TYPE_PROBE[1];
extern const struct vrt_type VCL_TYPE_REAL[1];
extern const struct vrt_type VCL_TYPE_STEVEDORE[1];
extern const struct vrt_type VCL_TYPE_STRANDS[1];
extern const struct vrt_type VCL_TYPE_STRING[1];
extern const struct vrt_type VCL_TYPE_STRINGS[1];
extern const struct vrt_type VCL_TYPE_STRING_LIST[1];
extern const struct vrt_type VCL_TYPE_SUB[1];
extern const struct vrt_type VCL_TYPE_TIME[1];
extern const struct vrt_type VCL_TYPE_VCL[1];
extern const struct vrt_type VCL_TYPE_VOID[1];

/* Compiled VCL Interface */
typedef int vcl_event_f(VRT_CTX, enum vcl_event_e);
typedef int vcl_init_f(VRT_CTX);
typedef void vcl_fini_f(VRT_CTX);
typedef void vcl_func_f(VRT_CTX);

struct VCL_conf {
	unsigned		magic;
#define VCL_CONF_MAGIC		0x7406c509      /* from /dev/random */

	unsigned		syntax;
	VCL_BACKEND		*default_director;
	VCL_PROBE		default_probe;
	unsigned		nref;
	const struct vpi_ref	*ref;

	int			nsrc;
	const char		**srcname;
	const char		**srcbody;

	int			nvmod;

	vcl_event_f		*event_vcl;
	vcl_func_f		*recv_func;
	vcl_func_f		*pipe_func;
	vcl_func_f		*pass_func;
	vcl_func_f		*hash_func;
	vcl_func_f		*purge_func;
	vcl_func_f		*miss_func;
	vcl_func_f		*hit_func;
	vcl_func_f		*deliver_func;
	vcl_func_f		*synth_func;
	vcl_func_f		*backend_fetch_func;
	vcl_func_f		*backend_response_func;
	vcl_func_f		*backend_error_func;
	vcl_func_f		*init_func;
	vcl_func_f		*fini_func;

};
