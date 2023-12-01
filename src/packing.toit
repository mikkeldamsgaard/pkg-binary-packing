import binary
import bytes show Buffer
import encoding.hex

/**
Handles packing data to a dynamic buffer with automatic position management.
*/
class PackingBuffer:
  byte-order_/binary.ByteOrder
  buffer_/Buffer

  constructor.private_ .byte-order_/binary.ByteOrder initial-size/int?:
    if initial-size:
      this.buffer_ = Buffer.with-initial-size initial-size
    else:
      this.buffer_ = Buffer

  /**
  Initializes a new packing buffer for big endian encoding. Optionally provide an $initial-size for
  the backing buffer.
  */
  constructor.be --initial-size/int?=null:
    return PackingBuffer.private_ binary.BIG-ENDIAN initial-size

  /**
  Initializes a new packing buffer for little endian encoding. Optionally provide an $initial-size for
  the backing buffer.
  */
  constructor.le --initial-size/int?=null:
    return PackingBuffer.private_ binary.LITTLE-ENDIAN initial-size

  /**
  Retrieves the packed binary buffer.
  */
  bytes -> ByteArray:
    return buffer_.bytes

  /**
  Appends an 8-bit integer to the packing buffer.
  */
  write-int8 val/int:
    ensure_ 1
    byte-order_.put-int8 buffer_.buffer_ current-position_ val
    current-position_++

  /**
  Appends an unsigned 8-bit integer to the packing buffer.
  */
  write-uint8 val/int:
    ensure_ 1
    byte-order_.put-uint8 buffer_.buffer_ current-position_ val
    current-position_++
  
  /**
  Appends a 16-bit integer to the packing buffer.
  */
  write-int16 val/int:
    ensure_ 2
    byte-order_.put-int16 buffer_.buffer_ current-position_ val
    current-position_ += 2

  /**
  Appends an unsigned 16-bit integer to the packing buffer.
  */
  write-uint16 val/int:
    ensure_ 2
    byte-order_.put-uint16 buffer_.buffer_ current-position_ val
    current-position_ += 2

  /**
  Appends a 32-bit integer to the packing buffer.
  */
  write-int32 val/int:
    ensure_ 4
    byte-order_.put-int32 buffer_.buffer_ current-position_ val
    current-position_ += 4

  /**
  Appends an unsigned 32-bit integer to the packing buffer.
  */
  write-uint32 val/int:
    ensure_ 4
    byte-order_.put-uint32 buffer_.buffer_ current-position_ val
    current-position_ += 4

  /**
  Appends a 64-bit integer to the packing buffer.
  */
  write-int64 val/int:
    ensure_ 8
    byte-order_.put-int64 buffer_.buffer_ current-position_ val
    current-position_ += 8

  /**
  Appends a 32-bit float to the packing buffer.
  */
  write-float32 val/float:
    ensure_ 4
    byte-order_.put-float32 buffer_.buffer_ current-position val
    current-position_ += 4

  /**
  Appends a 64-bit float to the packing buffer.
  */
  write-float64 val/float:
    ensure_ 8
    byte-order_.put-float64 buffer_.buffer_ current-position val
    current-position_ += 8

  /**
  Appends a byte array into this packing buffer.
  */
  write-byte-array data/ByteArray from/int=0 to/int=data.size:
    buffer_.write data from to

  /**
  Sets an 8-bit integer to the packing buffer at the specified $pos.
  */
  set-int8 pos/int val/int:
    ensure-at_ pos + 1
    byte-order_.put-int8 buffer_.buffer_ pos val

  /**
  Sets an unsigned 8-bit integer to the packing buffer at the specified $pos.
  */
  set-uint8 pos/int val/int:
    ensure-at_ pos + 1
    byte-order_.put-uint8 buffer_.buffer_ pos val
  
  /**
  Sets a 16-bit integer to the packing buffer at the specified $pos.
  */
  set-int16 pos/int val/int:
    ensure-at_ pos + 2
    byte-order_.put-int16 buffer_.buffer_ pos val

  /**
  Sets an unsigned 16-bit integer to the packing buffer at the specified $pos.
  */
  set-uint16 pos/int val/int:
    ensure-at_ pos + 2
    byte-order_.put-uint16 buffer_.buffer_ pos val

  /**
  Sets a 32-bit integer to the packing buffer at the specified $pos.
  */
  set-int32 pos/int val/int:
    ensure-at_ pos + 4
    byte-order_.put-int32 buffer_.buffer_ pos val

  /**
  Sets an unsigned 32-bit integer to the packing buffer at the specified $pos.
  */
  set-uint32 pos/int val/int:
    ensure-at_ pos + 4
    byte-order_.put-uint32 buffer_.buffer_ pos val

  /**
  Sets a 64-bit integer to the packing buffer at the specified $pos.
  */
  set-int64 pos/int val/int:
    ensure-at_ pos + 8
    byte-order_.put-int64 buffer_.buffer_ pos val

  /**
  Sets a byte array into this packing buffer at the specified $pos.
  */
  set-byte-array pos/int data/ByteArray from/int=0 to/int=data.size:
    count := from - to
    ensure-at_ pos + count
    buffer_.buffer_.replace pos data from to


  /**
  The position the next append will write to.    
  */
  current-position -> int: return current-position_

  /**
  resets the packing buffer, start writing from the beginning.
  */
  reset:
    current-position_ = 0  

  current-position_: return buffer_.offset_

  current-position_= val: buffer_.offset_ = val

  ensure-at_ pos/int:
    if pos > current-position_: ensure_ pos - current-position_

  ensure_ count:
    buffer_.ensure_ count


/**
Handles unpacking data from a byte array with automatic position management.
*/
class UnpackingBuffer:
  current-position_/int := 0
  byte-order_/binary.ByteOrder
  buffer_/ByteArray? := ?

  constructor.private_ .byte-order_ .buffer_:

  /**
  Initializes a new unpacking buffer for big endian decoding of the $buffer.
  */
  constructor.be buffer/ByteArray: return UnpackingBuffer.private_ binary.BIG-ENDIAN buffer
  
  /**
  Initializes a new unpacking buffer for little endian decoding of the $buffer.
  */
  constructor.le buffer/ByteArray: return UnpackingBuffer.private_ binary.LITTLE-ENDIAN buffer

  /**
  Reds out an 8-bit integer.
  */
  read-int8 -> int:
    verify-read_ 1
    val := byte-order_.int8 buffer_ current-position
    current-position_++
    return val

  /**
  Reds out an unsigned 8-bit integer.
  */
  read-uint8 -> int:
    //verify_read_ 1
    val := byte-order_.uint8 buffer_ current-position
    current-position_++
    return val

  /**
  Reds out a 16-bit integer.
  */
  read-int16 -> int:
    //verify_read_ 2
    val := byte-order_.int16 buffer_ current-position
    current-position_ += 2
    return val

  /**
  Reds out an unsigned 16-bit integer.
  */
  read-uint16 -> int:
    verify-read_ 2
    val := byte-order_.uint16 buffer_ current-position
    current-position_ += 2
    return val

  /**
  Reds out a 32-bit integer.
  */
  read-int32 -> int:
    verify-read_ 4
    val := byte-order_.int32 buffer_ current-position
    current-position_ += 4
    return val

  /**
  Reds out an unsigned 32-bit integer.
  */
  read-uint32 -> int:
    verify-read_ 4
    val := byte-order_.uint32 buffer_ current-position
    current-position_ += 4
    return val

  /**
  Reds out a 64-bit integer.
  */
  read-int64 -> int:
    verify-read_ 8
    val := byte-order_.int64 buffer_ current-position
    current-position_ += 8
    return val

  /**
  Reds out a 32-bit float.
  */
  read-float32 -> float:
    verify-read_ 4
    val := byte-order_.float32 buffer_ current-position
    current-position_ += 4
    return val

  /**
  Reds out a 64-bit float.
  */
  read-float64 -> float:
    verify-read_ 8
    val := byte-order_.float32 buffer_ current-position
    current-position_ += 8
    return val

  /**
  Reads out an array of size $count from the buffer
  */
  read-byte-array count/int -> ByteArray:
    verify-read_ count
    current-position_ += count
    return buffer_[current-position_ - count..current-position]

  /**
  The current reading position in the buffer. The next read operation will start at the returned index.
  */
  current-position: return current-position_

  /**
  Provides the numberof bytes available to read from this buffer.
  */
  available: return buffer_.size - current-position

  /**
  Skips $count positions in the read stream.
  */
  skip count/int:
    verify-read_ count
    current-position_ += count

  /**
  Returns the underlying buffer.
  */
  buffer -> ByteArray: return buffer_

  /**
  Sets a new buffer and resets the reader
  */
  buffer= buf/ByteArray:
    current-position_ = 0
    buffer_ = buf

  verify-read_ byte-count:
    if current-position_ + byte-count > buffer_.size: throw "READ_BEYOND_SIZE"



  to-string:
    return "$(hex.encode buffer_)"

  