#!/usr/bin/env python3
import struct, sys

def check(path):
    with open(path, 'rb') as f:
        data = f.read()
    if len(data) < 60:
        return False, "too short"
    if data[:4] != b'OggS':
        return False, "not OggS magic"
    # page header: 'OggS', version, header_type, granule(8), serial(4), seq(4), crc(4), nsegs(1)
    ver = data[4]
    if ver != 0:
        return False, f"bad version {ver}"
    nsegs = data[26]
    segtable_len = nsegs
    if len(data) < 27 + segtable_len:
        return False, "truncated segment table"
    lacing = data[27:27+nsegs]
    total = sum(lacing)
    if total == 0:
        return False, "empty payload"
    # Find the start of logical bitstream 0 (first packet = identification header for vorbis)
    payload = data[27+nsegs:]
    if payload[:7] == b'\x01vorbis':
        return True, f"valid vorbis, {total} payload bytes, {nsegs} segments"
    return True, f"Ogg stream (payload type {payload[:1]!r}), may still be valid"

files = [
    "/usr/share/sounds/Vicious/stereo/bell.oga",
    "/usr/share/sounds/Vicious/stereo/bell-window-system.oga",
    "/usr/share/sounds/Vicious/stereo/button-pressed.ogg",
    "/usr/share/sounds/Vicious/stereo/button-released.ogg",
    "/usr/share/sounds/Vicious/stereo/complete.oga",
    "/usr/share/sounds/Vicious/stereo/desktop-login.oga",
    "/usr/share/sounds/Vicious/stereo/desktop-logout.oga",
    "/usr/share/sounds/Vicious/stereo/device-added.oga",
    "/usr/share/sounds/Vicious/stereo/device-removed.oga",
    "/usr/share/sounds/Vicious/stereo/dialog-information.oga",
    "/usr/share/sounds/Vicious/stereo/dialog-warning.oga",
    "/usr/share/sounds/Vicious/stereo/audio-volume-change.oga",
]
for f in files:
    ok, msg = check(f)
    print(f"{'OK ' if ok else 'BAD'} {f.split('/')[-1]:28s} {msg}")