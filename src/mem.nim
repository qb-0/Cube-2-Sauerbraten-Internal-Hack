proc read*(address: ByteAddress, t: typedesc): t =
  cast[ptr t](address)[]

proc write*(address: ByteAddress, data: any) =
  cast[ptr typeof(data)](address)[] = data

proc readString*(address: ByteAddress): string =
  var r = read(address, array[0..50, char])
  $cast[cstring](r[0].unsafeAddr)