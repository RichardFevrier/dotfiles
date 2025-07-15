#!/usr/bin/env bash

for file in $(file ~/.ssh/* | grep 'PEM RSA private key' | cut -d ':' -f1); do
  chmod 600 $file
done
