#!/bin/bash
set -e
cmd="$@"

conda activate

exec $cmd
