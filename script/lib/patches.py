#!/usr/bin/env python

import os


def read_patch(patch_dir, patch_filename):
  """Read a patch from |patch_dir/filename| and amend the commit message with
  metadata about the patch file it came from."""
  ret = []
  added_filename_line = False
  with open(os.path.join(patch_dir, patch_filename)) as f:
    for l in f.readlines():
      if not added_filename_line and (l.startswith('diff -') or l.startswith('---')):
        ret.append('Patch-Filename: {}\n'.format(patch_filename))
        added_filename_line = True
      ret.append(l)
  return ''.join(ret)


def patch_from_dir(patch_dir):
  """Read a directory of patches into a format suitable for passing to
  'git am'"""
  with open(os.path.join(patch_dir, ".patches")) as f:
    patch_list = [l.rstrip('\n') for l in f.readlines()]

  return ''.join([
    read_patch(patch_dir, patch_filename)
    for patch_filename in patch_list
  ])
