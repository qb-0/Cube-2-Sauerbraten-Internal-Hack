import vec, mem, globals, gl

proc wts(pos: Vector3D): Vector2D =
  var 
    clip: Vector3D
    ndc: Vector2D

  clip.x = pos.x * ViewMatrix[0] + pos.y * ViewMatrix[4] + pos.z * ViewMatrix[8] + ViewMatrix[12]
  clip.y = pos.x * ViewMatrix[1] + pos.y * ViewMatrix[5] + pos.z * ViewMatrix[9] + ViewMatrix[13]
  # z = w
  clip.z = pos.x * ViewMatrix[3] + pos.y * ViewMatrix[7] + pos.z * ViewMatrix[11] + ViewMatrix[15]

  if clip.z < 0.1:
    raise newException(Exception, "WTS")

  ndc.x = clip.x / clip.z
  ndc.y = clip.y / clip.z

  result.x = (Resolution[0] / 2 * ndc.x) + (ndc.x + Resolution[0] / 2)
  result.y = (Resolution[1] / 2 * ndc.y) + (ndc.y + Resolution[1] / 2)

proc initEnt*(a: ByteAddress): Entity =
  result.address = a
  result.state = read(a + OState, byte)
  result.alive = result.state == 0
  result.health = read(a + OHealth, int32)
  result.armor = read(a + OArmor, int32)
  result.name = readString(a + OName)
  result.team = readString(a + OTeam)
  result.pos3d = read(a + OOrigin, Vector3D)
  result.fpos3d = result.pos3d
  result.fpos3d.z -= 15
  result.pos2d = result.pos3d.wts()
  result.fpos2d = result.fpos3d.wts()

proc box*(self: Entity, color: array[0..2, float32]) =
  let
    head = self.fpos2d.y - self.pos2d.y
    width = head / 2
    center = width / -2

  corner_box(
    self.pos2d.x + center,
    self.pos2d.y,
    width,
    head + 5,
    color,
    Black,
  )

proc healthBar*(self: Entity) = 
  let
    head = self.fpos2d.y - self.pos2d.y
    width = head / 2
    center = width / -2

  value_bar(
    self.fpos2d.x - center - 5,
    self.fpos2d.y + 5,
    self.fpos2d.x - center - 5,
    self.pos2d.y,
    2,
    150, self.health.float
  )

proc snapline*(self: Entity, color: array[0..2, float32]) =
  dashedLine(Resolution[0] / 2, Resolution[1] / 2, self.fpos2d.x, self.fpos2d.y, 1, color)

proc infos*(self: Entity) =
  HackFont.print(self.pos2d.x - self.name.len.float32 * 2.5, self.pos2d.y + 10, self.name, White)