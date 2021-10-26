import winim/inc/windef, subhook
import vec, gl

type
  Entity* = object
    address*: ByteAddress
    health*, armor*: int32
    state*: byte
    alive*: bool
    name*, team*: string
    pos3d*, fpos3d*: Vector3D
    pos2d*, fpos2d*: Vector2D

const
  PLocalPlayer* = 0x2A3528
  PRenderPlayer* = 0x1CB140
  PViewMatrix* = 0x32D040
  PResolution* = 0x345468

  OOrigin* = 0x0
  OHealth* = 0x178
  OArmor* = 0x180
  OState* = 0x77
  OName* = 0x274
  OTeam* = 0x378

const
  White* = [1.0.float32, 1.0, 1.0]
  Green* = [0.5.float32, 1.0, 0.6]
  Blue* = [0.0.float32, 0.0, 1.0]
  Red* = [1.0.float32, 0.0, 0.0]
  Yellow* = [1.0.float32, 0.8, 0.3]
  Black* = [0.0.float32, 0.0, 0.0]
  Lightblue* = [0.294.float32, 0.603, 0.905]
  Lightgrey* = [0.75.float32, 0.75, 0.75]

var
  LocalPlayer*: Entity
  HackContext*, GameContext*: HGLRC
  HackFont*: Font
  RenderPlayerHook*: Hook
  GameModule*: ByteAddress
  Resolution*: array[0..1, int32]
  ViewMatrix*: array[0..15, float32]

  # Settings
  STeamEsp*, SWallHack*: bool
