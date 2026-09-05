#!/usr/bin/env python3
"""Extract overlay info from concatenated cpio initrd"""
import sys

filepath = sys.argv[1]
with open(filepath, 'rb') as f:
    data = f.read()

print(f'File size: {len(data)} bytes')

# Find all 070701 or 070702 magic sequences
offset = 0
entries = []
while offset < len(data) - 116:
    magic = data[offset:offset+6]
    if magic in (b'070701', b'070702'):
        # Read namesize and filesize from the header
        # In newc format, all fields are ASCII hex strings
        # Offset 0-5: magic
        # Offset 6-13: dev
        # Offset 14-21: ino
        # Offset 22-27: mode
        # Offset 28-35: uid
        # Offset 36-43: gid
        # Offset 44-51: nlink
        # Offset 52-59: mtime
        # Offset 60-67: filesize
        # Offset 68-75: devmajor
        # Offset 76-83: devminor
        # Offset 84-91: rdevmajor
        # Offset 92-99: rdevminor
        # Offset 100-107: namesize
        # Offset 108-115: check
        # Offset 116+: name (namesize bytes)
        
        filesize_s = data[offset+60:offset+68].decode('ascii')
        namesize_s = data[offset+100:offset+108].decode('ascii')
        filesize = int(filesize_s, 16)
        namesize = int(namesize_s, 16)
        name = data[offset+116:offset+116+namesize].rstrip(b'\x00').decode('utf-8', errors='replace')
        
        hdr_total = 116 + namesize
        if hdr_total % 4:
            hdr_total += 4 - (hdr_total % 4)
        data_total = filesize
        if data_total % 4:
            data_total += 4 - (data_total % 4)
        total = hdr_total + data_total
        
        entries.append((offset, name, filesize, total))
        offset += total
        if total == 0:
            break
    else:
        break

print(f'Found {len(entries)} entries')
print()
# Show relevant entries
for i, (off, name, fsize, total) in enumerate(entries):
    if 'overlay' in name or 'modprobe' in name or 'modules.dep' in name or 'modules.alias' in name:
        print(f'  [{i+1}] @{off:#010x}: {name} (size={fsize})')

# Show first 20
print()
print('First 20 entries:')
for i, (off, name, fsize, total) in enumerate(entries[:20]):
    print(f'  [{i+1}] @{off:#010x}: {name} (size={fsize})')

# Find the TRAILER!!! entry (end of first cpio stream)
print()
for i, (off, name, fsize, total) in enumerate(entries):
    if 'TRAILER!!!' in name:
        print(f'First TRAILER!!! at entry {i+1}, offset {off:#010x}, next stream starts at {off+total:#010x}')
        # Now look at entries after TRAILER
        after = [e for e in entries[i+1:]]
        print(f'Entries after TRAILER: {len(after)}')
        for j, (off2, name2, fsize2, total2) in enumerate(after[:10]):
            print(f'  [{j+1}] @{off2:#010x}: {name2} (size={fsize2})')
        # Show overlay entries after TRAILER
        print()
        print('Overlay entries after TRAILER:')
        for j, (off2, name2, fsize2, total2) in enumerate(after):
            if 'overlay' in name2:
                print(f'  [{j+1}] @{off2:#010x}: {name2} (size={fsize2})')
        break
