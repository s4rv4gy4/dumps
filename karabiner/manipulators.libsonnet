local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';

{
  remap(fromKey, toKey, fromMods=null, toMods=null, conditions=null)::
    core.basic(
      core.from(fromKey, fromMods),
      core.to(toKey, toMods),
      { conditions: conditions }
    ),

  remapAny(fromKey, toKey, toMods=null, conditions=null)::
    self.remap(fromKey, toKey, mods.any, toMods, conditions),

  toShellCommand(fromKey, command, fromMods=null, conditions=null)::
    core.basic(
      core.from(fromKey, fromMods),
      core.toShell(command),
      { conditions: conditions }
    ),

  toOpenApp(fromKey, bundleId, fromMods=null, conditions=null)::
    core.basic(
      core.from(fromKey, fromMods),
      core.toApp(bundleId),
      { conditions: conditions }
    ),

  dualRole(key, tapKey, holdKey, holdMods=null, conditions=null)::
    core.basic(
      core.from(key, mods.any),
      core.to(holdKey, holdMods),
      {
        to_if_alone: [core.to(tapKey)],
        conditions: conditions,
      }
    ),

  tapHoldModifier(key, tapKey, holdModifier, conditions=null)::
    self.dualRole(key, tapKey, holdModifier, null, conditions),

  capsToEscCtrl(conditions=null)::
    self.dualRole(keys.capsLock, keys.escape, keys.leftControl, null, conditions),

  capsToEscHyper(conditions=null)::
    core.basic(
      core.from(keys.capsLock, mods.any),
      core.to(keys.leftShift, mods.toMods.leftMeh),
      {
        to_if_alone: [core.to(keys.escape)],
        conditions: conditions,
      }
    ),

  capsToHyper(conditions=null)::
    core.basic(
      core.from(keys.capsLock, mods.any),
      core.to(keys.leftShift, mods.toMods.leftMeh),
      {
        to_if_alone: [core.to(keys.capsLock, null, { hold_down_milliseconds: 100 })],
        conditions: conditions,
      }
    ),

  spaceShift(conditions=null)::
    self.dualRole(keys.spacebar, keys.spacebar, keys.leftShift, null, conditions),

  enterCtrl(conditions=null)::
    self.dualRole(keys.enter, keys.enter, keys.rightControl, null, conditions),

  layerToggle(key, layerName, conditions=null)::
    core.basic(
      core.from(key, mods.any),
      core.toVar(layerName, 1),
      {
        to_after_key_up: [core.toVar(layerName, 0)],
        conditions: conditions,
      }
    ),

  layerTapToggle(key, tapKey, layerName, conditions=null)::
    core.basic(
      core.from(key, mods.any),
      core.toVar(layerName, 1),
      {
        to_if_alone: [core.to(tapKey)],
        to_after_key_up: [core.toVar(layerName, 0)],
        conditions: conditions,
      }
    ),

  layerMapping(layerName, fromKey, toKey, toMods=null, fromMods=null)::
    core.basic(
      core.from(fromKey, if fromMods != null then fromMods else mods.any),
      core.to(toKey, toMods),
      { conditions: [cond.varIf(layerName, 1)] }
    ),

  simultaneous(keyList, toEvents, options={})::
    local simOpts = core.compact({
      key_down_order: core.get(options, 'key_down_order', 'strict'),
      key_up_order: core.get(options, 'key_up_order', 'strict_inverse'),
      detect_key_down_uninterruptedly: core.get(options, 'detect_key_down_uninterruptedly'),
      to_after_key_up: core.get(options, 'to_after_key_up'),
    });
    core.basic(
      core.fromSimultaneous(keyList, simOpts + { modifiers: mods.any }),
      toEvents,
      {
        parameters: if core.get(options, 'threshold') != null then
          core.params.simultaneousThreshold(options.threshold)
        else null,
        conditions: core.get(options, 'conditions'),
      }
    ),

  simultaneousLayer(keyList, layerName, options={})::
    self.simultaneous(
      keyList,
      [core.toVar(layerName, 1)],
      options + {
        to_after_key_up: [core.toVar(layerName, 0)],
      }
    ),

  viArrows(layerName)::
    [
      self.layerMapping(layerName, keys.h, keys.left),
      self.layerMapping(layerName, keys.j, keys.down),
      self.layerMapping(layerName, keys.k, keys.up),
      self.layerMapping(layerName, keys.l, keys.right),
    ],

  ijklArrows(layerName)::
    [
      self.layerMapping(layerName, keys.i, keys.up),
      self.layerMapping(layerName, keys.j, keys.left),
      self.layerMapping(layerName, keys.k, keys.down),
      self.layerMapping(layerName, keys.l, keys.right),
    ],

  wasdArrows(layerName)::
    [
      self.layerMapping(layerName, keys.w, keys.up),
      self.layerMapping(layerName, keys.a, keys.left),
      self.layerMapping(layerName, keys.s, keys.down),
      self.layerMapping(layerName, keys.d, keys.right),
    ],

  wordNavigation(layerName)::
    [
      self.layerMapping(layerName, keys.b, keys.left, mods.toMods.opt),
      self.layerMapping(layerName, keys.w, keys.right, mods.toMods.opt),
    ],

  lineNavigation(layerName)::
    [
      self.layerMapping(layerName, keys.n0, keys.left, mods.toMods.cmd),
      self.layerMapping(layerName, keys.n4, keys.right, mods.toMods.cmd),
    ],

  pageNavigation(layerName)::
    [
      self.layerMapping(layerName, keys.u, keys.pageUp),
      self.layerMapping(layerName, keys.d, keys.pageDown),
    ],

  mouseMove(layerName, speed=1536)::
    [
      self.layerMouse(layerName, keys.h, { x: -speed }),
      self.layerMouse(layerName, keys.j, { y: speed }),
      self.layerMouse(layerName, keys.k, { y: -speed }),
      self.layerMouse(layerName, keys.l, { x: speed }),
    ],

  mouseScroll(layerName, speed=32)::
    [
      self.layerMouse(layerName, keys.h, { horizontal_wheel: -speed }),
      self.layerMouse(layerName, keys.j, { vertical_wheel: speed }),
      self.layerMouse(layerName, keys.k, { vertical_wheel: -speed }),
      self.layerMouse(layerName, keys.l, { horizontal_wheel: speed }),
    ],

  layerMouse(layerName, fromKey, mouseAction)::
    core.basic(
      core.from(fromKey, mods.any),
      core.toMouse(mouseAction),
      { conditions: [cond.varIf(layerName, 1)] }
    ),

  appRemap(bundleId, fromKey, toKey, fromMods=null, toMods=null)::
    self.remap(fromKey, toKey, fromMods, toMods, [cond.app(bundleId)]),

  appRemapUnless(bundleId, fromKey, toKey, fromMods=null, toMods=null)::
    self.remap(fromKey, toKey, fromMods, toMods, [cond.appUnless(bundleId)]),

  deviceRemap(deviceId, fromKey, toKey, fromMods=null, toMods=null)::
    self.remap(fromKey, toKey, fromMods, toMods, [cond.device(deviceId)]),

  deviceRemapUnless(deviceId, fromKey, toKey, fromMods=null, toMods=null)::
    self.remap(fromKey, toKey, fromMods, toMods, [cond.deviceUnless(deviceId)]),

  doubleTap(key, toEvents, singleTapEvents=null, timeout=300)::
    local varName = 'double_tap_' + key;
    [
      core.basic(
        core.from(key, mods.any),
        toEvents,
        { conditions: [cond.varIf(varName, 1)] }
      ),
      core.basic(
        core.from(key, mods.any),
        [core.toVar(varName, 1)] + (if singleTapEvents != null then core.toArray(singleTapEvents) else []),
        {
          to_delayed_action: {
            to_if_invoked: [core.toVar(varName, 0)],
            to_if_canceled: [core.toVar(varName, 0)],
          },
          parameters: { 'basic.to_delayed_action_delay_milliseconds': timeout },
        }
      ),
    ],

  stickyToggle(key, modifier, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toSticky(modifier, 'toggle'),
      {}
    ),

  stickyOn(key, modifier, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toSticky(modifier, 'on'),
      {}
    ),

  stickyOff(key, modifier, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toSticky(modifier, 'off'),
      {}
    ),

  volumeUp(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.volumeUp),
      {}
    ),

  volumeDown(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.volumeDown),
      {}
    ),

  mute(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.mute),
      {}
    ),

  brightnessUp(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.brightnessUp),
      {}
    ),

  brightnessDown(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.brightnessDown),
      {}
    ),

  playPause(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.playPause),
      {}
    ),

  nextTrack(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.nextTrack),
      {}
    ),

  prevTrack(key, fromMods=null)::
    core.basic(
      core.from(key, fromMods),
      core.toConsumer(keys.consumer.prevTrack),
      {}
    ),
}
