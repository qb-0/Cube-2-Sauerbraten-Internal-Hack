from math import sqrt

type
  Vector2D* = object
    x*, y*: float32
  Vector3D* = object
    x*, y*, z*: float32

proc Vector*(x: float32, y: float32): Vector2D =
  Vector2D(x: x, y: y)
proc Vector*(x: float32, y: float32, z: float32): Vector3D =
  Vector3D(x: x, y: y, z: z)

proc `+`*(self: Vector2D, v: Vector2D): Vector2D =
  Vector2D(x: self.x + v.x, y: self.y + v.y)
proc `+`*(self: Vector3D, v: Vector3D): Vector3D =
  Vector3D(x: self.x + v.x, y: self.y + v.y, z: self.z + v.z)
proc `+`*(self: Vector2D, v: float32): Vector2D =
  Vector2D(x: self.x + v, y: self.y + v)
proc `+`*(self: Vector3D, v: float32): Vector3D =
  Vector3D(x: self.x + v, y: self.y + v, z: self.z + v)

proc `+=`*(self: var Vector2D, v: float32) =
  self.x = self.x + v
  self.y = self.y + v
proc `+=`*(self: var Vector3D, v: float32) =
  self.x = self.x + v
  self.y = self.y + v
  self.z = self.z + v
proc `+=`*(self: var Vector2D, v: Vector2D) =
  self.x = self.x + v.x
  self.y = self.y + v.y
proc `+=`*(self: var Vector3D, v: Vector3D) =
  self.x = self.x + v.x
  self.y = self.y + v.y
  self.z = self.z + v.z

proc `-`*(self: Vector2D, v: Vector2D): Vector2D =
  Vector2D(x: self.x - v.x, y: self.y - v.y)
proc `-`*(self: Vector3D, v: Vector3D): Vector3D =
  Vector3D(x: self.x - v.x, y: self.y - v.y, z: self.z - v.z)
proc `-`*(self: Vector2D, v: float32): Vector2D =
  Vector2D(x: self.x - v, y: self.y - v)
proc `-`*(self: Vector3D, v: float32): Vector3D =
  Vector3D(x: self.x - v, y: self.y - v, z: self.z - v)

proc `-=`*(self: var Vector2D, v: float32) =
  self.x = self.x - v
  self.y = self.y - v
proc `-=`*(self: var Vector3D, v: float32) =
  self.x = self.x - v
  self.y = self.y - v
  self.z = self.z - v
proc `-=`*(self: var Vector2D, v: Vector2D) =
  self.x = self.x - v.x
  self.y = self.y - v.y
proc `-=`*(self: var Vector3D, v: Vector3D) =
  self.x = self.x - v.x
  self.y = self.y - v.y
  self.z = self.z - v.z

proc `*`*(self: Vector2D, v: Vector2D): Vector2D =
  Vector2D(x: self.x * v.x, y: self.y * v.y)
proc `*`*(self: Vector3D, v: Vector3D): Vector3D =
  Vector3D(x: self.x * v.x, y: self.y * v.y, z: self.z * v.z)
proc `*`*(self: Vector2D, v: float32): Vector2D =
  Vector2D(x: self.x * v, y: self.y * v)
proc `*`*(self: Vector3D, v: float32): Vector3D =
  Vector3D(x: self.x * v, y: self.y * v, z: self.z * v)

proc `*=`*(self: var Vector2D, v: float32) =
  self.x = self.x * v
  self.y = self.y * v
proc `*=`*(self: var Vector3D, v: float32) =
  self.x = self.x * v
  self.y = self.y * v
  self.z = self.z * v
proc `*=`*(self: var Vector2D, v: Vector2D) =
  self.x = self.x * v.x
  self.y = self.y * v.y
proc `*=`*(self: var Vector3D, v: Vector3D) =
  self.x = self.x * v.x
  self.y = self.y * v.y
  self.z = self.z * v.z

proc `/`*(self: Vector2D, v: Vector2D): Vector2D =
  Vector2D(x: self.x / v.x, y: self.y / v.y)
proc `/`*(self: Vector3D, v: Vector3D): Vector3D =
  Vector3D(x: self.x / v.x, y: self.y / v.y, z: self.z / v.z)
proc `/`*(self: Vector2D, v: float32): Vector2D =
  Vector2D(x: self.x / v, y: self.y / v)
proc `/`*(self: Vector3D, v: float32): Vector3D =
  Vector3D(x: self.x / v, y: self.y / v, z: self.z / v)

proc `/=`*(self: var Vector2D, v: float32) =
  self.x = self.x / v
  self.y = self.y / v
proc `/=`*(self: var Vector3D, v: float32) =
  self.x = self.x / v
  self.y = self.y / v
  self.z = self.z / v
proc `/=`*(self: var Vector2D, v: Vector2D) =
  self.x = self.x / v.x
  self.y = self.y / v.y
proc `/=`*(self: var Vector3D, v: Vector3D) =
  self.x = self.x / v.x
  self.y = self.y / v.y
  self.z = self.z / v.z

proc magSq*(self: Vector2D): float32 =
  (self.x * self.x) + (self.y * self.y)
proc magSq*(self: Vector3D): float32 =
  (self.x * self.x) + (self.y * self.y) + (self.z * self.z)

proc mag*(self: Vector2D): float32 =
  sqrt(self.magSq())
proc mag*(self: Vector3D): float32 =
  sqrt(self.magSq())

proc dist*(self: Vector2D, v: Vector2D): float32 =
  mag(self - v)
proc dist*(self: Vector3D, v: Vector3D): float32 =
  mag(self - v)

proc normalize*(self: var Vector2D) =
  self /= self.mag()
proc normalize*(self: var Vector3D) =
  self /= self.mag()

proc perpendicular*(self: Vector2D): Vector2D =
  result.x = -self.y
  result.y = self.x