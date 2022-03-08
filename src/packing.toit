import binary
import bytes show Buffer

/**
Handles packing data to a dynamic buffer with automatic position management.
*/
class PackingBuffer:
  byte_order_/binary.ByteOrder
  buffer_/Buffer

  constructor.private_ .byte_order_/binary.ByteOrder initial_size/int?:
    if initial_size:
      this.buffer_ = Buffer.with_initial_size initial_size
    else:
      this.buffer_ = Buffer

  /**
  Initializes a new packing buffer for big endian encoding. Optionally provide an $initial_size for
  the backing buffer.
  */
  constructor.be --initial_size/int?=null:
    return PackingBuffer.private_ binary.BIG_ENDIAN initial_size

  /**
  Initializes a new packing buffer for little endian encoding. Optionally provide an $initial_size for
  the backing buffer.
  */
  constructor.le --initial_size/int?=null:
    return PackingBuffer.private_ binary.LITTLE_ENDIAN initial_size

  /**
  Retrieves the packed binary buffer.
  */
  bytes -> ByteArray:
    return buffer_.bytes

  /**
  Appends an 8-bit integer to the packing buffer.
  */
  write_int8 val/int:
    ensure_ 1
    byte_order_.put_int8 buffer_.buffer_ current_position_ val
    current_position_++

  /**
  Appends an unsigned 8-bit integer to the packing buffer.
  */
  write_uint8 val/int:
    ensure_ 1
    byte_order_.put_uint8 buffer_.buffer_ current_position_ val
    current_position_++
  
  /**
  Appends a 16-bit integer to the packing buffer.
  */
  write_int16 val/int:
    ensure_ 2
    byte_order_.put_int16 buffer_.buffer_ current_position_ val
    current_position_ += 2

  /**
  Appends an unsigned 16-bit integer to the packing buffer.
  */
  write_uint16 val/int:
    ensure_ 2
    byte_order_.put_uint16 buffer_.buffer_ current_position_ val
    current_position_ += 2

  /**
  Appends a 32-bit integer to the packing buffer.
  */
  write_int32 val/int:
    ensure_ 4
    byte_order_.put_int32 buffer_.buffer_ current_position_ val
    current_position_ += 4

  /**
  Appends an unsigned 32-bit integer to the packing buffer.
  */
  write_uint32 val/int:
    ensure_ 4
    byte_order_.put_uint32 buffer_.buffer_ current_position_ val
    current_position_ += 4

  /**
  Appends a 64-bit integer to the packing buffer.
  */
  write_int64 val/int:
    ensure_ 8
    byte_order_.put_int64 buffer_.buffer_ current_position_ val
    current_position_ += 8

  /**
  Appends a byte array into this packing buffer.
  */
  write_byte_array data/ByteArray from/int=0 to/int=data.size:
    buffer_.write data from to

  /**
  Sets an 8-bit integer to the packing buffer at the specified $pos.
  */
  set_int8 pos/int val/int:
    ensure_at_ pos + 1
    byte_order_.put_int8 buffer_.buffer_ pos val

  /**
  Sets an unsigned 8-bit integer to the packing buffer at the specified $pos.
  */
  set_uint8 pos/int val/int:
    ensure_at_ pos + 1
    byte_order_.put_uint8 buffer_.buffer_ pos val
  
  /**
  Sets a 16-bit integer to the packing buffer at the specified $pos.
  */
  set_int16 pos/int val/int:
    ensure_at_ pos + 2
    byte_order_.put_int16 buffer_.buffer_ pos val

  /**
  Sets an unsigned 16-bit integer to the packing buffer at the specified $pos.
  */
  set_uint16 pos/int val/int:
    ensure_at_ pos + 2
    byte_order_.put_uint16 buffer_.buffer_ pos val

  /**
  Sets a 32-bit integer to the packing buffer at the specified $pos.
  */
  set_int32 pos/int val/int:
    ensure_at_ pos + 4
    byte_order_.put_int32 buffer_.buffer_ pos val

  /**
  Sets an unsigned 32-bit integer to the packing buffer at the specified $pos.
  */
  set_uint32 pos/int val/int:
    ensure_at_ pos + 4
    byte_order_.put_uint32 buffer_.buffer_ pos val

  /**
  Sets a 64-bit integer to the packing buffer at the specified $pos.
  */
  set_int64 pos/int val/int:
    ensure_at_ pos + 8
    byte_order_.put_int64 buffer_.buffer_ pos val

  /**
  Sets a byte array into this packing buffer at the specified $pos.
  */
  set_byte_array pos/int data/ByteArray from/int=0 to/int=data.size:
    count := from - to
    ensure_at_ pos + count
    buffer_.buffer_.replace pos data from to


  /**
  The position the next append will write to.    
  */
  current_position -> int: return current_position_

  /**
  resets the packing buffer, start writing from the beginning.
  */
  reset:
    current_position_ = 0  

  current_position_: return buffer_.offset_

  current_position_= val: buffer_.offset_ = val

  ensure_at_ pos/int:
    if pos > current_position_: ensure_ pos - current_position_

  ensure_ count:
    buffer_.ensure_ count


/**
Handles unpacking data from a byte array with automatic position management.
*/
class UnpackingBuffer:
  current_position_/int := 0
  byte_order_/binary.ByteOrder
  buffer_/ByteArray

  constructor.private_ .byte_order_ .buffer_:

  /**
  Initializes a new unpacking buffer for big endian decoding of the $buffer.
  */
  constructor.be buffer/ByteArray: return UnpackingBuffer.private_ binary.BIG_ENDIAN buffer
  
  /**
  Initializes a new unpacking buffer for little endian decoding of the $buffer.
  */
  constructor.le buffer/ByteArray: return UnpackingBuffer.private_ binary.LITTLE_ENDIAN buffer

  /**
  Reds out an 8-bit integer.
  */
  read_int8 -> int:
    verify_read_ 1
    val := byte_order_.int8 buffer_ current_position
    current_position_++
    return val

  /**
  Reds out an unsigned 8-bit integer.
  */
  read_uint8 -> int:
    verify_read_ 1
    val := byte_order_.uint8 buffer_ current_position
    current_position_++
    return val

  /**
  Reds out a 16-bit integer.
  */
  read_int16 -> int:
    verify_read_ 2
    val := byte_order_.int16 buffer_ current_position
    current_position_ += 2
    return val

  /**
  Reds out an unsigned 16-bit integer.
  */
  read_uint16 -> int:
    verify_read_ 2
    val := byte_order_.uint16 buffer_ current_position
    current_position_ += 2
    return val

  /**
  Reds out a 32-bit integer.
  */
  read_int32 -> int:
    verify_read_ 4
    val := byte_order_.int32 buffer_ current_position
    current_position_ += 4
    return val

  /**
  Reds out an unsigned 32-bit integer.
  */
  read_uint32 -> int:
    verify_read_ 4
    val := byte_order_.uint32 buffer_ current_position
    current_position_ += 4
    return val

  /**
  Reds out a 64-bit integer.
  */
  read_int64 -> int:
    verify_read_ 8
    val := byte_order_.int64 buffer_ current_position
    current_position_ += 8
    return val

  /**
  Reads out an array of size $count from the buffer
  */
  read_byte_array count/int -> ByteArray:
    verify_read_ count
    current_position_ += count
    return buffer_[current_position_-count..current_position]

  /**
  The current reading position in the buffer. The next read operation will start at the returned index.
  */
  current_position: return current_position_

  /**
  Provides the numberof bytes available to read from this buffer.
  */
  available: return buffer_.size - current_position

  /**
  Skips $count positions in the read stream.
  */
  skip count/int:
    verify_read_ count
    current_position_ += count

  verify_read_ byte_count:
    if current_position_ + byte_count > buffer_.size: throw "READ_BEYOND_SIZE"

  