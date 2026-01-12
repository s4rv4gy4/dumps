local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';
local man = import './manipulators.libsonnet';
local layers = import './layers.libsonnet';
local apps = import './applications.libsonnet';

{
  hyper:: {
    capsLockEscape()::
      man.capsToEscHyper(),

    capsLockToggle()::
      man.capsToHyper(),

    tabHyper()::
      man.dualRole(keys.tab, keys.tab, keys.leftShift, mods.toMods.leftMeh),

    rightCmdHyper()::
      core.basic(
        core.from(keys.rightCommand, mods.any),
        core.to(keys.rightShift, mods.toMods.rightMeh),
        {}
      ),

    rightOptHyper()::
      core.basic(
        core.from(keys.rightOption, mods.any),
        core.to(keys.rightShift, mods.toMods.rightMeh),
        {}
      ),
  },

  dualRole:: {
    capsCtrlEsc():: man.capsToEscCtrl(),

    spaceShift():: man.spaceShift(),

    enterCtrl():: man.enterCtrl(),

    backspaceCtrl()::
      man.dualRole(keys.backspace, keys.backspace, keys.leftControl),

    tabHyper()::
      man.dualRole(keys.tab, keys.tab, keys.leftShift, mods.toMods.leftMeh),

    leftShiftParen()::
      core.basic(
        core.from(keys.leftShift, mods.any),
        core.to(keys.leftShift),
        { to_if_alone: [core.to(keys.n9, mods.toMods.shift)] }
      ),

    rightShiftParen()::
      core.basic(
        core.from(keys.rightShift, mods.any),
        core.to(keys.rightShift),
        { to_if_alone: [core.to(keys.n0, mods.toMods.shift)] }
      ),

    shiftsForParens()::
      [self.leftShiftParen(), self.rightShiftParen()],
  },

  navigation:: {
    viCapsLock()::
      local layerName = 'caps_vi_mode';
      layers.layer(layerName, keys.capsLock, [
        { from: keys.h, to: keys.left },
        { from: keys.j, to: keys.down },
        { from: keys.k, to: keys.up },
        { from: keys.l, to: keys.right },
        { from: keys.u, to: keys.pageUp },
        { from: keys.d, to: keys.pageDown },
        { from: keys.n0, to: keys.left, toMods: mods.toMods.cmd },
        { from: keys.n4, to: keys.right, toMods: mods.toMods.cmd },
        { from: keys.b, to: keys.left, toMods: mods.toMods.opt },
        { from: keys.w, to: keys.right, toMods: mods.toMods.opt },
        { from: keys.g, to: keys.up, toMods: mods.toMods.cmd },
        { from: keys.semicolon, to: keys.down, toMods: mods.toMods.cmd },
      ], { tap: keys.escape }).manipulators(),

    spaceFn()::
      local layerName = 'spacefn_mode';
      layers.layer(layerName, keys.spacebar, [
        { from: keys.h, to: keys.left },
        { from: keys.j, to: keys.down },
        { from: keys.k, to: keys.up },
        { from: keys.l, to: keys.right },
        { from: keys.u, to: keys.pageUp },
        { from: keys.d, to: keys.pageDown },
        { from: keys.y, to: keys.home },
        { from: keys.n, to: keys.end },
        { from: keys.b, to: keys.spacebar },
      ], { tap: keys.spacebar }).manipulators(),

    ijklRightCmd()::
      [
        man.remap(keys.i, keys.up, mods.rightCmdAny),
        man.remap(keys.j, keys.left, mods.rightCmdAny),
        man.remap(keys.k, keys.down, mods.rightCmdAny),
        man.remap(keys.l, keys.right, mods.rightCmdAny),
      ],

    wasdCapsLock()::
      local layerName = 'caps_wasd_mode';
      layers.layer(layerName, keys.capsLock, [
        { from: keys.w, to: keys.up },
        { from: keys.a, to: keys.left },
        { from: keys.s, to: keys.down },
        { from: keys.d, to: keys.right },
        { from: keys.q, to: keys.home },
        { from: keys.e, to: keys.end },
        { from: keys.r, to: keys.pageUp },
        { from: keys.f, to: keys.pageDown },
      ], { tap: keys.escape }).manipulators(),

    pcHomeEnd()::
      [
        man.remap(keys.home, keys.left, mods.any, mods.toMods.cmd),
        man.remap(keys.end, keys.right, mods.any, mods.toMods.cmd),
      ],
  },

  functionKeys:: {
    fnNumbers()::
      [
        man.remap(keys.n1, keys.f1, mods.fnAny),
        man.remap(keys.n2, keys.f2, mods.fnAny),
        man.remap(keys.n3, keys.f3, mods.fnAny),
        man.remap(keys.n4, keys.f4, mods.fnAny),
        man.remap(keys.n5, keys.f5, mods.fnAny),
        man.remap(keys.n6, keys.f6, mods.fnAny),
        man.remap(keys.n7, keys.f7, mods.fnAny),
        man.remap(keys.n8, keys.f8, mods.fnAny),
        man.remap(keys.n9, keys.f9, mods.fnAny),
        man.remap(keys.n0, keys.f10, mods.fnAny),
        man.remap(keys.hyphen, keys.f11, mods.fnAny),
        man.remap(keys.equalSign, keys.f12, mods.fnAny),
      ],

    fnMedia()::
      [
        core.basic(core.from(keys.f1, mods.fnAny), core.toConsumer(keys.consumer.brightnessDown)),
        core.basic(core.from(keys.f2, mods.fnAny), core.toConsumer(keys.consumer.brightnessUp)),
        core.basic(core.from(keys.f3, mods.fnAny), core.to(keys.up, mods.toMods.ctrl)),
        core.basic(core.from(keys.f4, mods.fnAny), core.toConsumer(keys.consumer.launchpad)),
        core.basic(core.from(keys.f5, mods.fnAny), core.toConsumer(keys.consumer.keyboardBrightnessDown)),
        core.basic(core.from(keys.f6, mods.fnAny), core.toConsumer(keys.consumer.keyboardBrightnessUp)),
        core.basic(core.from(keys.f7, mods.fnAny), core.toConsumer(keys.consumer.prevTrack)),
        core.basic(core.from(keys.f8, mods.fnAny), core.toConsumer(keys.consumer.playPause)),
        core.basic(core.from(keys.f9, mods.fnAny), core.toConsumer(keys.consumer.nextTrack)),
        core.basic(core.from(keys.f10, mods.fnAny), core.toConsumer(keys.consumer.mute)),
        core.basic(core.from(keys.f11, mods.fnAny), core.toConsumer(keys.consumer.volumeDown)),
        core.basic(core.from(keys.f12, mods.fnAny), core.toConsumer(keys.consumer.volumeUp)),
      ],
  },

  media:: {
    withLayer(layerName, trigger)::
      layers.build.mediaControls(layerName, trigger).manipulators(),

    hyperVolume()::
      [
        core.basic(core.from(keys.openBracket, mods.hyper), core.toConsumer(keys.consumer.volumeDown)),
        core.basic(core.from(keys.closeBracket, mods.hyper), core.toConsumer(keys.consumer.volumeUp)),
        core.basic(core.from(keys.backslash, mods.hyper), core.toConsumer(keys.consumer.mute)),
      ],

    hyperPlayback()::
      [
        core.basic(core.from(keys.p, mods.hyper), core.toConsumer(keys.consumer.playPause)),
        core.basic(core.from(keys.comma, mods.hyper), core.toConsumer(keys.consumer.prevTrack)),
        core.basic(core.from(keys.period, mods.hyper), core.toConsumer(keys.consumer.nextTrack)),
      ],
  },

  launcher:: {
    hyperApps(mappings)::
      [
        core.basic(
          core.from(m.key, mods.hyper),
          core.toApp(m.app),
          {}
        )
        for m in mappings
      ],

    commonApps()::
      self.hyperApps([
        { key: keys.t, app: 'com.apple.Terminal' },
        { key: keys.s, app: 'com.apple.Safari' },
        { key: keys.c, app: 'com.google.Chrome' },
        { key: keys.f, app: 'com.apple.finder' },
        { key: keys.n, app: 'com.apple.Notes' },
        { key: keys.m, app: 'com.apple.mail' },
        { key: keys.a, app: 'com.apple.ActivityMonitor' },
        { key: keys.v, app: 'com.microsoft.VSCode' },
        { key: keys.i, app: 'com.googlecode.iterm2' },
        { key: keys.k, app: 'com.tinyspeck.slackmacgap' },
      ]),

    withLayer(layerName, trigger, mappings)::
      layers.layer(layerName, trigger, [
        { from: m.key, to: [core.toApp(m.app)] }
        for m in mappings
      ]).manipulators(),
  },

  textEditing:: {
    emacsNavigation()::
      [
        man.remap(keys.f, keys.right, mods.ctrlAny),
        man.remap(keys.b, keys.left, mods.ctrlAny),
        man.remap(keys.p, keys.up, mods.ctrlAny),
        man.remap(keys.n, keys.down, mods.ctrlAny),
        man.remap(keys.a, keys.left, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.e, keys.right, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.d, keys.del, mods.ctrlAny),
        man.remap(keys.h, keys.backspace, mods.ctrlAny),
        core.basic(
          core.from(keys.k, mods.ctrlAny),
          [core.to(keys.right, mods.toMods.cmdShift), core.to(keys.x, mods.toMods.cmd)],
          {}
        ),
      ],

    wordDeletion()::
      [
        man.remap(keys.backspace, keys.backspace, mods.optAny, mods.toMods.opt),
        man.remap(keys.del, keys.del, mods.optAny, mods.toMods.opt),
      ],

    pcStyle()::
      [
        man.remap(keys.a, keys.a, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.c, keys.c, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.v, keys.v, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.x, keys.x, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.z, keys.z, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.y, keys.z, mods.ctrlAny, mods.toMods.cmdShift),
        man.remap(keys.s, keys.s, mods.ctrlAny, mods.toMods.cmd),
        man.remap(keys.f, keys.f, mods.ctrlAny, mods.toMods.cmd),
      ],
  },

  windowManagement:: {
    rectangleStyle()::
      [
        core.basic(core.from(keys.left, mods.hyper), core.to(keys.left, mods.toMods.ctrlOpt)),
        core.basic(core.from(keys.right, mods.hyper), core.to(keys.right, mods.toMods.ctrlOpt)),
        core.basic(core.from(keys.up, mods.hyper), core.to(keys.up, mods.toMods.ctrlOpt)),
        core.basic(core.from(keys.down, mods.hyper), core.to(keys.down, mods.toMods.ctrlOpt)),
        core.basic(core.from(keys.m, mods.hyper), core.to(keys.enter, mods.toMods.ctrlOpt)),
      ],

    desktopSwitch()::
      [
        core.basic(core.from(keys.n1, mods.hyper), core.to(keys.n1, mods.toMods.ctrl)),
        core.basic(core.from(keys.n2, mods.hyper), core.to(keys.n2, mods.toMods.ctrl)),
        core.basic(core.from(keys.n3, mods.hyper), core.to(keys.n3, mods.toMods.ctrl)),
        core.basic(core.from(keys.n4, mods.hyper), core.to(keys.n4, mods.toMods.ctrl)),
        core.basic(core.from(keys.n5, mods.hyper), core.to(keys.n5, mods.toMods.ctrl)),
      ],
  },

  special:: {
    doubleTapCapsLock()::
      man.doubleTap(keys.capsLock, [core.to(keys.capsLock)]),

    doubleTapShiftCapsLock()::
      man.doubleTap(keys.leftShift, [core.to(keys.capsLock)], [core.to(keys.leftShift)]),

    escapeToGrave(bundleIds)::
      man.appRemap(bundleIds, keys.escape, keys.grave),

    safeCmdQ()::
      man.doubleTap(keys.q, [core.to(keys.q, mods.toMods.cmd)], null, 500),

    safeCmdW()::
      man.doubleTap(keys.w, [core.to(keys.w, mods.toMods.cmd)], null, 300),
  },

  language:: {
    capsLockToggle(source1, source2)::
      [
        core.basic(
          core.from(keys.capsLock, mods.any),
          core.toInputSource(source1),
          { conditions: [cond.inputSource(source2)] }
        ),
        core.basic(
          core.from(keys.capsLock, mods.any),
          core.toInputSource(source2),
          { conditions: [cond.inputSource(source1)] }
        ),
      ],

    cmdLanguageSwitch(leftSource, rightSource)::
      [
        core.basic(
          core.from(keys.leftCommand, mods.any),
          core.to(keys.leftCommand),
          { to_if_alone: [core.toInputSource(leftSource)] }
        ),
        core.basic(
          core.from(keys.rightCommand, mods.any),
          core.to(keys.rightCommand),
          { to_if_alone: [core.toInputSource(rightSource)] }
        ),
      ],
  },

  mouseEmulation:: {
    withLayer(layerName, trigger, speed=1536)::
      local scrollSpeed = 32;
      layers.layer(layerName, trigger, [
        { from: keys.h, to: [core.toMouse({ x: -speed })] },
        { from: keys.j, to: [core.toMouse({ y: speed })] },
        { from: keys.k, to: [core.toMouse({ y: -speed })] },
        { from: keys.l, to: [core.toMouse({ x: speed })] },
        { from: keys.f, to: [{ pointing_button: 'button1' }] },
        { from: keys.d, to: [{ pointing_button: 'button2' }] },
        { from: keys.s, to: [{ pointing_button: 'button3' }] },
        { from: keys.u, to: [core.toMouse({ vertical_wheel: -scrollSpeed })] },
        { from: keys.n, to: [core.toMouse({ vertical_wheel: scrollSpeed })] },
        { from: keys.y, to: [core.toMouse({ horizontal_wheel: -scrollSpeed })] },
        { from: keys.m, to: [core.toMouse({ horizontal_wheel: scrollSpeed })] },
      ], { notification: 'Mouse Mode' }).manipulators(),
  },
}
