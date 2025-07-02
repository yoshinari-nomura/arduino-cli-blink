#!/bin/bash

# Find names of compiler commands from compile_commands.json
#
function find_compilers() {
  local compile_commands_json="$1"

  sed -n '/"arguments":/{n; s/^ *"//; s/",$//; p}' \
      "$compile_commands_json" | sort | uniq
}

# Show default include path for the compiler
#
function default_include_path() {
  local compiler="$1"

  echo "" | "$compiler" -xc++ -E -v - 2>&1 | \
    sed -n '1,/^#include <...> .* here:/d; /^End of/q; s/^ *//p'
#    sed -n '1,/^#include <...> .* here:/d; /^End of/q; s/^ */        -I/p'
}

################################################################

echo "Add below in your .clangd:" >&2

cat <<EOH
CompileFlags:
    Add: [
EOH

for compiler in $(find_compilers build/compile_commands.json)
do
  for include_path in $(default_include_path "$compiler")
  do
    echo "      -I$(realpath $include_path)"
  done
done

cat <<EOF
    ]
    Remove: [
        -fstrict-volatile-bitfields,
        -fno-tree-switch-conversion,
    ]
EOF
