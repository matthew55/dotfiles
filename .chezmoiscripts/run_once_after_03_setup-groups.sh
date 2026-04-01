#!/usr/bin/env bash
# Setup the groups for our local user.
# Note: The user should already be in the wheel group with access to sudo

sudo usermod -aG input $USER
