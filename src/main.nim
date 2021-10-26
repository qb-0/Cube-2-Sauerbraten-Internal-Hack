import segfaults
import winim, opengl, subhook
import globals, mem, entity, gl

type renderPlayerDef = proc(fpsent: ByteAddress, playermodelinfo: ByteAddress, team: int32, fade: float32, mainpass: bool) {.fastcall.}

template checkToggle(key: int, option: bool) =
  if GetAsyncKeyState(key).bool: option = not option

proc handleEnt(entAddr: ByteAddress) =
  var e: Entity
  try:
    e = initEnt(entAddr)
  except:
    # Death Ent, WTS
    return

  if e.alive:
    let
      sameTeam =  e.team == LocalPlayer.team
      c = if sameTeam: Lightblue else: Red

    if sameTeam and not STeamEsp: return

    e.box(c)
    e.snapline(c)
    e.infos()
    e.healthbar()

proc hkRenderPlayer(fpsent: ByteAddress, playermodelinfo: ByteAddress, team: int32, fade: float32, mainpass: bool) =
  checkToggle(VK_NUMPAD0, SWallHack)
  checkToggle(VK_NUMPAD1, STeamEsp)

  GameContext = wglGetCurrentContext()
  let gHandle = wglGetCurrentDC()
  if HackContext == 0:
    HackContext = wglCreateContext(gHandle)
    wglMakeCurrent(gHandle, HackContext)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(0, Resolution[0].GLdouble, 0, Resolution[1].GLdouble, -1, 1)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    HackFont = initFont(10, "Tahoma")

  ViewMatrix = read(GameModule + PViewMatrix, array[0..15, float32])
  
  try:
    LocalPlayer = initEnt(read(GameModule + PLocalPlayer, ByteAddress))
  except:
    discard
  
  wglMakeCurrent(gHandle, HackContext)
  if LocalPlayer.address != fpsent: handleEnt(fpsent)
  wglMakeCurrent(gHandle, GameContext)

  if SWallHack:
    glDepthFunc(GL_ALWAYS)
    glEnable(GL_DEPTH_TEST)
  let o = cast[renderPlayerDef](RenderPlayerHook.getTrampoline())
  o(fpsent, playermodelinfo, team, fade, mainpass)

proc mainThread =
  AllocConsole()
  discard stdout.reopen("CONOUT$", fmWrite)
  
  loadExtensions()
  GameModule = GetModuleHandleA("sauerbraten.exe")
  Resolution = read(GameModule + PResolution, array[0..1, int32])
  RenderPlayerHook = initHook(
    cast[pointer](GameModule + PRenderPlayer),
    cast[pointer](cast[ByteAddress](hkRenderPlayer)),
    SUBHOOK_64BIT_OFFSET
  )
  discard RenderPlayerHook.install()

when isMainModule:
  CloseHandle(
    CreateThread(
      cast[LPSECURITY_ATTRIBUTES](nil), 
      0.SIZE_T,
      cast[LPTHREAD_START_ROUTINE](mainThread), 
      cast[LPVOID](nil),
      0.DWORD,
      cast[LPDWORD](nil)
    )
  )