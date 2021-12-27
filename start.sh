#!/bin/bash
set -eu

epmd -daemon

CLASSPATH=".:/work/otp/lib/jinterface/java_src"
cd java
java -classpath "$CLASSPATH" SimpleServer
