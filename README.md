## Utility for managing packing and unpacking of binary messages

Packing and unpacking of binary messages. Supports different endianess and signed/unsigned integers

Packing example
```
packer := PackingBuffer.le
packer.write_uint32 0x42
packer.bytes // This would return #[0x42,0,0,0]
```

Unpacking example
```
unpacker := UnpackingBuffer.be message
a := unpacker.read_uint16
b := unpacker.read_uint16
// If message is #[0x02, 0x10, 0x43, 0xa0], a would become 0x210 and b would be 0x43a0
```


