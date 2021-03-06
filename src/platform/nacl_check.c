/*
 * Copyright 2008 The Native Client Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can
 * be found in the LICENSE file.
 */

/*
 * NaCl service runtime, support for check macros.
 */

#include "src/platform/nacl_check.h"

#if _DEBUG
int nacl_check_debug_mode = 1;
#else
int nacl_check_debug_mode = 0;
#endif

void NaClCheckIntern(const char *fmt, ...) {
  va_list ap;

  va_start(ap, fmt);
  NaClLogV(LOG_FATAL, fmt, ap);
  va_end(ap);
}
