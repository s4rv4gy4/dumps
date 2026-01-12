local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';

{
  ids:: cond.devices,

  id(vendor_id=null, product_id=null, options={})::
    cond.deviceId(
      vendor_id=vendor_id,
      product_id=product_id,
      location_id=core.get(options, 'location_id'),
      is_keyboard=core.get(options, 'is_keyboard'),
      is_pointing_device=core.get(options, 'is_pointing_device'),
      is_touch_bar=core.get(options, 'is_touch_bar'),
      is_built_in_keyboard=core.get(options, 'is_built_in_keyboard'),
    ),

  vendors:: {
    apple: 1452,
    logitech: 1133,
    microsoft: 1118,
    razer: 5426,
    corsair: 6940,
    steelseries: 4152,
    hyperx: 2385,
    hhkb: 1278,
    realforce: 2131,
    ducky: 1241,
    das: 9456,
    filco: 1241,
    leopold: 1241,
    varmilo: 1241,
    anne: 1241,
    keychron: 1452,
    nuphy: 1452,
    wooting: 12625,
    kinesis: 10730,
    ergodox: 12951,
    zsa: 12951,
    qmk: 65261,
  },

  products:: {
    hhkbPro2: { vendor_id: 1278, product_id: 33 },
    hhkbBT: { vendor_id: 1278, product_id: 515 },
    hhkbHybrid: { vendor_id: 1278, product_id: 514 },

    realforce87: { vendor_id: 2131, product_id: 256 },
    realforceR2: { vendor_id: 2131, product_id: 272 },
    realforceR3: { vendor_id: 2131, product_id: 288 },

    keychronK1: { vendor_id: 1452, product_id: 591 },
    keychronK2: { vendor_id: 1452, product_id: 592 },
    keychronK3: { vendor_id: 1452, product_id: 593 },
    keychronK6: { vendor_id: 1452, product_id: 596 },
    keychronK8: { vendor_id: 1452, product_id: 598 },

    ergodoxEZ: { vendor_id: 12951, product_id: 6505 },
    moonlander: { vendor_id: 12951, product_id: 6505 },
    planckEZ: { vendor_id: 12951, product_id: 6505 },

    kinesisAdvantage: { vendor_id: 10730, product_id: 258 },
    kinesisAdvantage360: { vendor_id: 10730, product_id: 360 },
  },

  isDevice(identifier):: cond.device(identifier),
  notDevice(identifier):: cond.deviceUnless(identifier),

  deviceConnected(identifier):: cond.deviceExists(identifier),
  deviceNotConnected(identifier):: cond.deviceExistsUnless(identifier),

  isApple:: cond.device(cond.devices.apple),
  notApple:: cond.deviceUnless(cond.devices.apple),

  isBuiltIn:: cond.device(cond.devices.builtIn),
  isExternal:: cond.device(cond.devices.external),

  isKeyboard:: cond.device(cond.devices.keyboard),
  isMouse:: cond.device(cond.devices.mouse),

  forDevice(identifier, manipulators)::
    [
      m + { conditions: [cond.device(identifier)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ],

  exceptDevice(identifier, manipulators)::
    [
      m + { conditions: [cond.deviceUnless(identifier)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ],

  forExternal(manipulators)::
    self.forDevice(cond.devices.external, manipulators),

  forBuiltIn(manipulators)::
    self.forDevice(cond.devices.builtIn, manipulators),

  configs:: {
    pcKeyboardSwap(identifier=null)::
      local deviceCond = if identifier != null then [cond.device(identifier)]
                         else [cond.deviceUnless(cond.devices.apple)];
      [
        core.basic(
          core.from(keys.leftCommand, mods.any),
          core.to(keys.leftOption),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.leftOption, mods.any),
          core.to(keys.leftCommand),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.rightCommand, mods.any),
          core.to(keys.rightOption),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.rightOption, mods.any),
          core.to(keys.rightCommand),
          { conditions: deviceCond }
        ),
      ],

    hhkbArrows(identifier=null)::
      local deviceCond = if identifier != null then [cond.device(identifier)] else [];
      [
        core.basic(
          core.from(keys.openBracket, mods.fnAny),
          core.to(keys.up),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.semicolon, mods.fnAny),
          core.to(keys.left),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.quote, mods.fnAny),
          core.to(keys.down),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.backslash, mods.fnAny),
          core.to(keys.right),
          { conditions: deviceCond }
        ),
      ],

    sixtyPercentArrows(identifier=null)::
      local deviceCond = if identifier != null then [cond.device(identifier)] else [];
      [
        core.basic(
          core.from(keys.i, mods.rightShiftAny),
          core.to(keys.up),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.j, mods.rightShiftAny),
          core.to(keys.left),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.k, mods.rightShiftAny),
          core.to(keys.down),
          { conditions: deviceCond }
        ),
        core.basic(
          core.from(keys.l, mods.rightShiftAny),
          core.to(keys.right),
          { conditions: deviceCond }
        ),
      ],

    disableInternalWhenExternal(externalDevice)::
      [
        core.basic(
          core.fromAny(keys.any.keyCode),
          [],
          { conditions: [cond.device(cond.devices.builtIn), cond.deviceExists(externalDevice)] }
        ),
      ],

    logitechFixes(identifier=null)::
      local logitechId = { vendor_id: 1133 };
      local deviceCond = if identifier != null then [cond.device(identifier)]
                         else [cond.device(logitechId)];
      [
      ] + $.configs.pcKeyboardSwap(if identifier != null then identifier else logitechId),

    microsoftFixes(identifier=null)::
      local msId = { vendor_id: 1118 };
      local deviceCond = if identifier != null then [cond.device(identifier)]
                         else [cond.device(msId)];
      $.configs.pcKeyboardSwap(if identifier != null then identifier else msId),
  },

  keyboardTypes:: {
    ansi: 'ansi',
    iso: 'iso',
    jis: 'jis',

    isAnsi:: cond.keyboardType('ansi'),
    isIso:: cond.keyboardType('iso'),
    isJis:: cond.keyboardType('jis'),
    notAnsi:: cond.keyboardTypeUnless('ansi'),
    notIso:: cond.keyboardTypeUnless('iso'),
    notJis:: cond.keyboardTypeUnless('jis'),
  },

  mouse:: {
    remapButton(fromButton, toButton, conditions=null)::
      core.mouseBasic(
        core.fromMouse(fromButton),
        { pointing_button: toButton },
        { conditions: conditions }
      ),

    buttonToKey(button, key, keyMods=null, conditions=null)::
      core.mouseBasic(
        core.fromMouse(button),
        core.to(key, keyMods),
        { conditions: conditions }
      ),

    buttonToShell(button, command, conditions=null)::
      core.mouseBasic(
        core.fromMouse(button),
        core.toShell(command),
        { conditions: conditions }
      ),

    configs:: {
      browserNavigation(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.safari,
          cond.apps.chrome,
          cond.apps.firefox,
        ];
        [
          $.mouse.buttonToKey(keys.mouse.button4, keys.openBracket, mods.toMods.cmd, [cond.app(apps)]),
          $.mouse.buttonToKey(keys.mouse.button5, keys.closeBracket, mods.toMods.cmd, [cond.app(apps)]),
        ],

      middleClickNewTab(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.safari,
          cond.apps.chrome,
          cond.apps.firefox,
        ];
        [
          $.mouse.buttonToKey(keys.mouse.button3, keys.t, mods.toMods.cmd, [cond.app(apps)]),
        ],
    },
  },
}
