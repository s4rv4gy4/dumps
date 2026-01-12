local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';
local man = import './manipulators.libsonnet';
local layers = import './layers.libsonnet';
local apps = import './applications.libsonnet';
local devices = import './devices.libsonnet';
local templates = import './templates.libsonnet';

{
  hyperKeyEssentials:: {
    title: 'Hyper Key Essentials',
    description: 'Caps Lock to Hyper (hold) / Escape (tap) with app launchers',
    rules: [
      core.rule('Caps Lock to Hyper/Escape', [
        templates.hyper.capsLockEscape(),
      ]),
      core.rule('Hyper + Letters to Launch Apps', templates.launcher.commonApps()),
    ],
  },

  viNavigationMode:: {
    title: 'Vi Navigation Mode',
    description: 'Caps Lock + HJKL for Vi-style navigation',
    rules: [
      core.rule('Vi Navigation with Caps Lock', templates.navigation.viCapsLock()),
    ],
  },

  spaceFnLayer:: {
    title: 'SpaceFN Layer',
    description: 'Space as layer key for navigation',
    rules: [
      core.rule('SpaceFN Navigation', templates.navigation.spaceFn()),
    ],
  },

  pcKeyboardCompat:: {
    title: 'PC Keyboard Compatibility',
    description: 'Swap Command/Option for PC keyboards, PC-style shortcuts',
    rules: [
      core.rule('Swap Cmd/Opt for non-Apple keyboards', devices.configs.pcKeyboardSwap()),
      core.rule('PC-style text shortcuts', templates.textEditing.pcStyle()),
      core.rule('PC-style Home/End', templates.navigation.pcHomeEnd()),
    ],
  },

  dualRoleModifiers:: {
    title: 'Dual-Role Modifiers',
    description: 'Tap modifiers for special keys, hold for modifier',
    rules: [
      core.rule('Caps Lock: Escape/Control', [templates.dualRole.capsCtrlEsc()]),
      core.rule('Shifts for Parentheses', templates.dualRole.shiftsForParens()),
      core.rule('Enter: Enter/Control', [templates.dualRole.enterCtrl()]),
    ],
  },

  mediaControls:: {
    title: 'Media Controls',
    description: 'Hyper key media controls',
    rules: [
      core.rule('Hyper + Volume Controls', templates.media.hyperVolume()),
      core.rule('Hyper + Playback Controls', templates.media.hyperPlayback()),
    ],
  },

  functionKeyLayer:: {
    title: 'Function Key Layer',
    description: 'Fn + Numbers for F-keys',
    rules: [
      core.rule('Fn + Numbers to F-keys', templates.functionKeys.fnNumbers()),
    ],
  },

  emacsNavigation:: {
    title: 'Emacs Navigation',
    description: 'Emacs-style text navigation shortcuts',
    rules: [
      core.rule('Emacs Navigation Keys', templates.textEditing.emacsNavigation()),
    ],
  },

  windowManagement:: {
    title: 'Window Management',
    description: 'Hyper key window management shortcuts',
    rules: [
      core.rule('Rectangle-style Window Management', templates.windowManagement.rectangleStyle()),
      core.rule('Desktop Switching', templates.windowManagement.desktopSwitch()),
    ],
  },

  terminalPowerUser:: {
    title: 'Terminal Power User',
    description: 'Terminal-specific enhancements',
    rules: [
      core.rule('Option as Escape prefix in terminals', apps.configs.terminal.optionAsEscape()),
    ],
  },

  browserEnhancements:: {
    title: 'Browser Enhancements',
    description: 'Browser-specific shortcuts',
    rules: [
      core.rule('Vim-style Tab Navigation', apps.configs.browser.vimTabs()),
    ],
  },

  mouseKeysMode:: {
    title: 'Mouse Keys Mode',
    description: 'Control mouse with keyboard',
    rules: [
      core.rule('Mouse Keys with D key', templates.mouseEmulation.withLayer('mouse_mode', keys.d)),
    ],
  },

  sixtyPercentEssentials:: {
    title: '60% Keyboard Essentials',
    description: 'Essential mappings for 60% keyboards',
    rules: [
      core.rule('Fn + Numbers to F-keys', templates.functionKeys.fnNumbers()),
      core.rule('Right Shift + IJKL to Arrows', devices.configs.sixtyPercentArrows()),
      core.rule('Caps Lock to Escape/Control', [templates.dualRole.capsCtrlEsc()]),
    ],
  },

  safeQuit:: {
    title: 'Safe Quit',
    description: 'Prevent accidental Cmd+Q',
    rules: [
      core.rule('Double-tap Cmd+Q to quit', templates.special.safeCmdQ()),
    ],
  },

  capsLockEnhancements:: {
    title: 'Caps Lock Enhancements',
    description: 'Multiple Caps Lock improvements',
    rules: [
      core.rule('Caps Lock to Hyper/Escape', [templates.hyper.capsLockEscape()]),
      core.rule('Double-tap Shift for Caps Lock', templates.special.doubleTapShiftCapsLock()),
    ],
  },

  developerEssentials:: {
    title: 'Developer Essentials',
    description: 'Essential shortcuts for developers',
    rules: [
      core.rule('Hyper Key', [templates.hyper.capsLockEscape()]),
      core.rule('Vi Navigation', templates.navigation.viCapsLock()),
      core.rule('App Launchers', templates.launcher.commonApps()),
      core.rule('Terminal Enhancements', apps.configs.terminal.optionAsEscape()),
    ],
  },

  minimalSetup:: {
    title: 'Minimal Setup',
    description: 'Just the essentials',
    rules: [
      core.rule('Caps Lock to Escape/Control', [templates.dualRole.capsCtrlEsc()]),
    ],
  },

  hhkbStyle:: {
    title: 'HHKB Style',
    description: 'HHKB-inspired layout',
    rules: [
      core.rule('HHKB Arrow Keys', devices.configs.hhkbArrows()),
      core.rule('Caps Lock to Control', [man.remapAny(keys.capsLock, keys.leftControl)]),
    ],
  },

  productivityPack:: {
    title: 'Productivity Pack',
    description: 'Comprehensive productivity enhancements',
    rules: [
      core.rule('Hyper Key', [templates.hyper.capsLockEscape()]),
      core.rule('App Launchers', templates.launcher.commonApps()),
      core.rule('Window Management', templates.windowManagement.rectangleStyle()),
      core.rule('Media Controls', templates.media.hyperVolume() + templates.media.hyperPlayback()),
    ],
  },

  gamingMode:: {
    title: 'Gaming Mode',
    description: 'Disable problematic shortcuts for gaming',
    rules: [
      core.rule('Disable Cmd+Tab in games', [
        core.basic(
          core.from(keys.tab, mods.cmdAny),
          [],
          { conditions: [cond.app(cond.apps.steam)] }
        ),
      ]),
    ],
  },

  vmCompatibility:: {
    title: 'Virtual Machine Compatibility',
    description: 'Better keyboard handling in VMs',
    rules: [
      core.rule('Swap Ctrl/Cmd in VMs', [
        core.basic(
          core.from(keys.leftCommand, mods.any),
          core.to(keys.leftControl),
          { conditions: [apps.inVirtualMachine] }
        ),
        core.basic(
          core.from(keys.leftControl, mods.any),
          core.to(keys.leftCommand),
          { conditions: [apps.inVirtualMachine] }
        ),
      ]),
    ],
  },

  symbolLayer:: {
    title: 'Symbol Layer',
    description: 'Easy access to programming symbols',
    rules: [
      core.rule('Symbol Layer with Right Option',
        layers.build.symbolLayer('symbol_layer', keys.rightOption).manipulators()
      ),
    ],
  },

  numpadLayer:: {
    title: 'Numpad Layer',
    description: 'Virtual numpad on right hand',
    rules: [
      core.rule('Numpad Layer with Right Command',
        layers.build.numpad('numpad_layer', keys.rightCommand).manipulators()
      ),
    ],
  },

  wasdNavigation:: {
    title: 'WASD Navigation',
    description: 'WASD arrow keys with Caps Lock',
    rules: [
      core.rule('WASD Navigation', templates.navigation.wasdCapsLock()),
    ],
  },

  completePowerUser:: {
    title: 'Complete Power User',
    description: 'All-in-one power user configuration',
    rules: [
      core.rule('Hyper Key (Caps Lock)', [templates.hyper.capsLockEscape()]),
      core.rule('Vi Navigation Layer', templates.navigation.viCapsLock()),
      core.rule('App Launchers', templates.launcher.commonApps()),
      core.rule('Window Management', templates.windowManagement.rectangleStyle()),
      core.rule('Desktop Switching', templates.windowManagement.desktopSwitch()),
      core.rule('Media Controls', templates.media.hyperVolume() + templates.media.hyperPlayback()),
      core.rule('Fn + Numbers to F-keys', templates.functionKeys.fnNumbers()),
      core.rule('Terminal Enhancements', apps.configs.terminal.optionAsEscape()),
      core.rule('Browser Tab Navigation', apps.configs.browser.vimTabs()),
      core.rule('Safe Quit', templates.special.safeCmdQ()),
      core.rule('Double-tap Shift for Caps Lock', templates.special.doubleTapShiftCapsLock()),
    ],
  },

  ergonomicSetup:: {
    title: 'Ergonomic Setup',
    description: 'Reduce pinky strain and improve ergonomics',
    rules: [
      core.rule('Caps Lock to Control/Escape', [templates.dualRole.capsCtrlEsc()]),
      core.rule('Space to Shift when held', [templates.dualRole.spaceShift()]),
      core.rule('Enter to Control when held', [templates.dualRole.enterCtrl()]),
      core.rule('Shifts for Parentheses', templates.dualRole.shiftsForParens()),
    ],
  },

  writersToolkit:: {
    title: "Writer's Toolkit",
    description: 'Shortcuts optimized for writing',
    rules: [
      core.rule('Emacs Navigation', templates.textEditing.emacsNavigation()),
      core.rule('Word Deletion', templates.textEditing.wordDeletion()),
      core.rule('Caps Lock to Escape/Control', [templates.dualRole.capsCtrlEsc()]),
    ],
  },

  generate(preset)::
    core.complexModifications(preset.title, preset.rules),

  list:: [
    'hyperKeyEssentials',
    'viNavigationMode',
    'spaceFnLayer',
    'pcKeyboardCompat',
    'dualRoleModifiers',
    'mediaControls',
    'functionKeyLayer',
    'emacsNavigation',
    'windowManagement',
    'terminalPowerUser',
    'browserEnhancements',
    'mouseKeysMode',
    'sixtyPercentEssentials',
    'safeQuit',
    'capsLockEnhancements',
    'developerEssentials',
    'minimalSetup',
    'hhkbStyle',
    'productivityPack',
    'gamingMode',
    'vmCompatibility',
    'symbolLayer',
    'numpadLayer',
    'wasdNavigation',
    'completePowerUser',
    'ergonomicSetup',
    'writersToolkit',
  ],
}
