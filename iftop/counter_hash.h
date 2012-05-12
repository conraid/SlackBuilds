/*
 * addr_hash.h:
 *
 */

#ifndef __ADDR_HASH_H_ /* include guard */
#define __ADDR_HASH_H_

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include "hash.h"

typedef struct {
  unsigned long long sent;
  unsigned long long recv;
} counter_type;

typedef counter_type key_type;      /* index into hash table */

hash_type* counter_hash_create(void);

#endif /* __ADDR_HASH_H_ */
