#!/bin/bash
set -eu

CLASSPATH=".:/work/otp/lib/jinterface/java_src"
cd java
java -classpath "$CLASSPATH" SimpleServer
