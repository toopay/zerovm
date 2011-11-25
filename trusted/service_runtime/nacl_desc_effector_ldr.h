/*
 * Copyright 2008 The Native Client Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can
 * be found in the LICENSE file.
 */

/* @file
 *
 * Service runtime effector subclass used for all application threads.
 */

#ifndef NATIVE_CLIENT_SRC_TRUSTED_SERVICE_RUNTIME_NACL_DESC_EFFECTOR_LDR_H_
#define NATIVE_CLIENT_SRC_TRUSTED_SERVICE_RUNTIME_NACL_DESC_EFFECTOR_LDR_H_

#include "include/nacl_base.h"

#include "trusted/service_runtime/nacl_app_thread.h"
#include "trusted/service_runtime/sel_ldr.h"

#include "trusted/desc/nacl_desc_effector.h"

EXTERN_C_BEGIN

struct NaClAppThread;

struct NaClDescEffectorLdr {
  struct NaClDescEffector     base;
  struct NaClApp              *nap;
};

/* placement new style ctor */
extern int NaClDescEffectorLdrCtor(struct NaClDescEffectorLdr *self,
                                   struct NaClApp             *nap);

EXTERN_C_END

#endif  // NATIVE_CLIENT_SRC_TRUSTED_SERVICE_RUNTIME_NACL_DESC_EFFECTOR_LDR_H_