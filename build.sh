#!/bin/bash
set -eu

ERL_ROOT=`erl -noshell -eval 'io:format("~s\n", [code:root_dir()]), init:stop().'`

echo $ERL_ROOT

cd java
erlc '+{be,java}' exj.idl
