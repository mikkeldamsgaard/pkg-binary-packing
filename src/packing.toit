import binary
import bytes show Buffer

class PackingBuffer:
  byte_order_/binary.ByteOrder
  buffer_/Buffer

  constructor .byte_order_/binary.ByteOrder initial_size/int?:
    if initial_size:
      this.buffer_ = Buffer.with_initial_size initial_size
    else:
      this.buffer_ = Buffer

  constructor.be --initial_size/int?=null:
    return PackingBuffer binary.BIG_ENDIAN initial_size

  constructor.le --initial_size/int?=null:
    return PackingBuffer binary.LITTLE_ENDIAN initial_size

  bytes -> ByteArray:
    return buffer_.bytes

  write_int8 val/int:
    ensure_ 1
    byte_order_.put_int8 buffer_.buffer_ current_position_ val
    current_position_++

  write_uint8 val/int:
    ensure_ 1
    byte_order_.put_uint8 buffer_.buffer_ current_position_ val
    current_position_++
  
  write_int16 val/int:
    ensure_ 2
    byte_order_.put_int16 buffer_.buffer_ current_position_ val
    current_position_ += 2

  write_uint16 val/int:
    ensure_ 2
    byte_order_.put_uint16 buffer_.buffer_ current_position_ val
    current_position_ += 2

  write_int32 val/int:
    ensure_ 4
    byte_order_.put_int32 buffer_.buffer_ current_position_ val
    current_position_ += 4

  write_uint32 val/int:
    ensure_ 4
    byte_order_.put_uint32 buffer_.buffer_ current_position_ val
    current_position_ += 4

  write_int64 val/int:
    ensure_ 8
    byte_order_.put_int64 buffer_.buffer_ current_position_ val
    current_position_ += 8

  write_byte_array data/ByteArray from/int=0 to/int=data.size:
    buffer_.write data from to

  reset:
    current_position_ = 0
    

  current_position_: return buffer_.offset_
  current_position_= val: buffer_.offset_ = val

  ensure_ count:
    buffer_.ensure_ count

class UnpackingBuffer:
  current_position_/int := 0
  byte_order_/binary.ByteOrder
  buffer_/ByteArray

  constructor .byte_order_ .buffer_:
  constructor.be buffer/ByteArray: return UnpackingBuffer binary.BIG_ENDIAN buffer
  constructor.le buffer/ByteArray: return UnpackingBuffer binary.LITTLE_ENDIAN buffer

  current_position: return current_position_

  read_int8 -> int:
    verify_read_ 1
    val := byte_order_.int8 buffer_ current_position
    current_position_++
    return val

  read_uint8 -> int:
    verify_read_ 1
    val := byte_order_.uint8 buffer_ current_position
    current_position_++
    return val

  read_int16 -> int:
    verify_read_ 2
    val := byte_order_.int16 buffer_ current_position
    current_position_ += 2
    return val

  read_uint16 -> int:
    verify_read_ 2
    val := byte_order_.uint16 buffer_ current_position
    current_position_ += 2
    return val

  read_int32 -> int:
    verify_read_ 4
    val := byte_order_.int32 buffer_ current_position
    current_position_ += 4
    return val

  read_uint32 -> int:
    verify_read_ 4
    val := byte_order_.uint32 buffer_ current_position
    current_position_ += 4
    return val

  read_int64 -> int:
    verify_read_ 8
    val := byte_order_.int64 buffer_ current_position
    current_position_ += 8
    return val

  read_byte_array count/int -> ByteArray:
    verify_read_ count
    current_position_ += count
    return buffer_[current_position_-count..current_position]

  available: return buffer_.size - current_position

  skip count/int:
    verify_read_ count
    current_position_ += count

  verify_read_ byte_count:
    if current_position_ + byte_count > buffer_.size: throw "READ_BEYOND_SIZE"

  