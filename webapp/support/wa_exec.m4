dnl
dnl Copyright 1999-2004 The Apache Software Foundation
dnl
dnl Licensed under the Apache License, Version 2.0 (the "License");
dnl you may not use this file except in compliance with the License.
dnl You may obtain a copy of the License at
dnl
dnl     http://www.apache.org/licenses/LICENSE-2.0
dnl
dnl Unless required by applicable law or agreed to in writing, software
dnl distributed under the License is distributed on an "AS IS" BASIS,
dnl WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl See the License for the specific language governing permissions and
dnl limitations under the License.
dnl

dnl --------------------------------------------------------------------------
dnl Author Pier Fumagalli <pier@betaversion.org>
dnl Version $Id$
dnl --------------------------------------------------------------------------

dnl --------------------------------------------------------------------------
dnl WA_EXEC
dnl   Execute a program filtering its output (pretty printing).
dnl
dnl   Parameters:
dnl     $1 => name of the variable containing the return value (error code).
dnl     $2 => name of the binary/script to invoke
dnl     $3 => message used for pretty printing output
dnl     $4 => the directory where the command must be executed
dnl --------------------------------------------------------------------------
AC_DEFUN(
  [WA_EXEC],
  [
    wa_exec_curdir="`pwd`"
    if test -d "$4" ; then
      cd "$4"
    else
      AC_MSG_ERROR([can't switch to directory $4]) 
    fi

    echo "  invoking \"$2\""
    echo "  in directory \"$4\""
    echo "-1" > retvalue.tmp

    set $2
    wa_exec_file=[$]1
    if test ! -x "${wa_exec_file}" ; then
      cd "${wa_exec_curdir}"
      AC_MSG_ERROR([cannot find or execute \"${wa_exec_file}\" in \"$4\"])
      exit 1
    fi
    unset wa_exec_file

    {
      $2
      echo "wa_exec_retvalue $?"
    } | {
      wa_exec_ret=0
      while true ; do
        read wa_exec_first wa_exec_line
        if test ! "$?" -eq "0" ; then
          break
        else
          if test "${wa_exec_first}" = "wa_exec_retvalue" ; then
            wa_exec_ret="${wa_exec_line}"
          else
            if test -n "${wa_exec_line}" ; then
             echo "    $3: ${wa_exec_first} ${wa_exec_line}"
            fi
          fi
        fi
      done
      echo "${wa_exec_ret}" > retvalue.tmp
      unset wa_exec_first
      unset wa_exec_line
      unset wa_exec_ret
    }

    $1="`cat retvalue.tmp`"
    rm -f retvalue.tmp
    echo "  execution of \"$2\""
    echo "  returned with value \"${$1}\""

    cd "${wa_exec_curdir}"
    unset wa_exec_curdir
  ])
