/* Copyright (C) 1997, 1999, 2000 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * ISO C99 7.6: Floating-point environment	<fenv.h>
 */

#ifndef _FENV_H
#define _FENV_H	1
enum
  {
    FE_INEXACT = 1 << (31 - 6),
#define FE_INEXACT	FE_INEXACT
    FE_DIVBYZERO = 1 << (31 - 5),
#define FE_DIVBYZERO	FE_DIVBYZERO
    FE_UNDERFLOW = 1 << (31 - 4),
#define FE_UNDERFLOW	FE_UNDERFLOW
    FE_OVERFLOW = 1 << (31 - 3),
#define FE_OVERFLOW	FE_OVERFLOW
    FE_INVALID = 1 << (31 - 2),
#define FE_INVALID	FE_INVALID
    FE_INVALID_SNAN = 1 << (31 - 7),
# define FE_INVALID_SNAN	FE_INVALID_SNAN

    /* Inf - Inf */
    FE_INVALID_ISI = 1 << (31 - 8),
# define FE_INVALID_ISI		FE_INVALID_ISI

    /* Inf / Inf */
    FE_INVALID_IDI = 1 << (31 - 9),
# define FE_INVALID_IDI		FE_INVALID_IDI

    /* 0 / 0 */
    FE_INVALID_ZDZ = 1 << (31 - 10),
# define FE_INVALID_ZDZ		FE_INVALID_ZDZ

    /* Inf * 0 */
    FE_INVALID_IMZ = 1 << (31 - 11),
# define FE_INVALID_IMZ		FE_INVALID_IMZ

    /* Comparison with NaN or SNaN.  */
    FE_INVALID_COMPARE = 1 << (31 - 12),
# define FE_INVALID_COMPARE	FE_INVALID_COMPARE
    FE_INVALID_SOFTWARE = 1 << (31 - 21),
# define FE_INVALID_SOFTWARE	FE_INVALID_SOFTWARE
    FE_INVALID_SQRT = 1 << (31 - 22),
# define FE_INVALID_SQRT	FE_INVALID_SQRT
    FE_INVALID_INTEGER_CONVERSION = 1 << (31 - 23)
# define FE_INVALID_INTEGER_CONVERSION	FE_INVALID_INTEGER_CONVERSION

# define FE_ALL_INVALID \
        (FE_INVALID_SNAN | FE_INVALID_ISI | FE_INVALID_IDI | FE_INVALID_ZDZ \
	 | FE_INVALID_IMZ | FE_INVALID_COMPARE | FE_INVALID_SOFTWARE \
	 | FE_INVALID_SQRT | FE_INVALID_INTEGER_CONVERSION)
  };

#define FE_ALL_EXCEPT \
	(FE_INEXACT | FE_DIVBYZERO | FE_UNDERFLOW | FE_OVERFLOW | FE_INVALID)
enum
  {
    FE_TONEAREST = 0,
#define FE_TONEAREST	FE_TONEAREST
    FE_TOWARDZERO = 1,
#define FE_TOWARDZERO	FE_TOWARDZERO
    FE_UPWARD = 2,
#define FE_UPWARD	FE_UPWARD
    FE_DOWNWARD = 3
#define FE_DOWNWARD	FE_DOWNWARD
  };

typedef unsigned int fexcept_t;

typedef double fenv_t;

extern const fenv_t __fe_dfl_env;
#define FE_DFL_ENV	(&__fe_dfl_env)
extern const fenv_t __fe_enabled_env;
# define FE_ENABLED_ENV	(&__fe_enabled_env)

extern const fenv_t __fe_nonieee_env;
# define FE_NONIEEE_ENV	(&__fe_nonieee_env)

extern const fenv_t *__fe_nomask_env (void);
# define FE_NOMASK_ENV	FE_ENABLED_ENV
extern const fenv_t *__fe_mask_env (void);
extern int feclearexcept (int __excepts);

extern int fegetexceptflag (fexcept_t *__flagp, int __excepts);
extern int feraiseexcept (int __excepts);
extern int fesetexceptflag (__const fexcept_t *__flagp, int __excepts);
extern int fetestexcept (int __excepts);
extern int fegetround (void);
extern int fesetround (int __rounding_direction);
extern int fegetenv (fenv_t *__envp);
extern int feholdexcept (fenv_t *__envp);
extern int fesetenv (__const fenv_t *__envp);
extern int feupdateenv (__const fenv_t *__envp);
extern int feenableexcept (int __excepts);
extern int fedisableexcept (int __excepts);
extern int fegetexcept (void);

#endif /* fenv.h */
