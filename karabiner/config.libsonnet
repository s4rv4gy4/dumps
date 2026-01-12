local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';

{
  defaults:: {
    check_for_updates_on_startup: true,
    show_in_menu_bar: true,
    show_profile_name_in_menu_bar: false,
    unsafe_ui: false,
  },

  global(options={})::
    core.compact($.defaults + options),

  deviceDefaults:: {
    disable_built_in_keyboard_if_exists: false,
    fn_function_keys: [],
    ignore: false,
    manipulate_caps_lock_led: true,
    simple_modifications: [],
    treat_as_built_in_keyboard: false,
  },

  device(identifiers, options={})::
    core.compact({
      identifiers: identifiers,
    } + $.deviceDefaults + options),

  profileDefaults:: {
    complex_modifications: {
      parameters: {
        'basic.simultaneous_threshold_milliseconds': 50,
        'basic.to_delayed_action_delay_milliseconds': 500,
        'basic.to_if_alone_timeout_milliseconds': 1000,
        'basic.to_if_held_down_threshold_milliseconds': 500,
        'mouse_motion_to_scroll.speed': 100,
      },
      rules: [],
    },
    devices: [],
    fn_function_keys: [],
    name: 'Default',
    selected: true,
    simple_modifications: [],
    virtual_hid_keyboard: {
      country_code: 0,
      indicate_sticky_modifier_keys_state: true,
      mouse_key_xy_scale: 100,
    },
  },

  profile(name, options={})::
    core.compact($.profileDefaults + {
      name: name,
    } + options),

  parameters:: {
    default: {
      'basic.simultaneous_threshold_milliseconds': 50,
      'basic.to_delayed_action_delay_milliseconds': 500,
      'basic.to_if_alone_timeout_milliseconds': 1000,
      'basic.to_if_held_down_threshold_milliseconds': 500,
      'mouse_motion_to_scroll.speed': 100,
    },

    fastSimultaneous: {
      'basic.simultaneous_threshold_milliseconds': 30,
    },

    slowSimultaneous: {
      'basic.simultaneous_threshold_milliseconds': 100,
    },

    quickTap: {
      'basic.to_if_alone_timeout_milliseconds': 500,
    },

    slowTap: {
      'basic.to_if_alone_timeout_milliseconds': 1500,
    },

    quickHold: {
      'basic.to_if_held_down_threshold_milliseconds': 250,
    },

    slowHold: {
      'basic.to_if_held_down_threshold_milliseconds': 750,
    },

    fastScroll: {
      'mouse_motion_to_scroll.speed': 200,
    },

    slowScroll: {
      'mouse_motion_to_scroll.speed': 50,
    },
  },

  simpleModification(from, to)::
    {
      from: { key_code: from },
      to: [{ key_code: to }],
    },

  simpleModifications:: {
    capsToEscape: $.simpleModification(keys.capsLock, keys.escape),
    capsToControl: $.simpleModification(keys.capsLock, keys.leftControl),
    capsToBackspace: $.simpleModification(keys.capsLock, keys.backspace),

    escapeToGrave: $.simpleModification(keys.escape, keys.grave),
    escapeToCapsLock: $.simpleModification(keys.escape, keys.capsLock),

    leftCmdToLeftOpt: $.simpleModification(keys.leftCommand, keys.leftOption),
    leftOptToLeftCmd: $.simpleModification(keys.leftOption, keys.leftCommand),
    rightCmdToRightOpt: $.simpleModification(keys.rightCommand, keys.rightOption),
    rightOptToRightCmd: $.simpleModification(keys.rightOption, keys.rightCommand),

    fnToLeftCtrl: $.simpleModification(keys.fn, keys.leftControl),
    leftCtrlToFn: $.simpleModification(keys.leftControl, keys.fn),
  },

  fnFunctionKey(from, to)::
    {
      from: { key_code: from },
      to: [{ key_code: to }],
    },

  fnFunctionKeys:: {
    standard: [
      $.fnFunctionKey(keys.f1, keys.consumer.brightnessDown),
      $.fnFunctionKey(keys.f2, keys.consumer.brightnessUp),
      $.fnFunctionKey(keys.f3, 'mission_control'),
      $.fnFunctionKey(keys.f4, 'launchpad'),
      $.fnFunctionKey(keys.f5, keys.consumer.keyboardBrightnessDown),
      $.fnFunctionKey(keys.f6, keys.consumer.keyboardBrightnessUp),
      $.fnFunctionKey(keys.f7, keys.consumer.prevTrack),
      $.fnFunctionKey(keys.f8, keys.consumer.playPause),
      $.fnFunctionKey(keys.f9, keys.consumer.nextTrack),
      $.fnFunctionKey(keys.f10, keys.consumer.mute),
      $.fnFunctionKey(keys.f11, keys.consumer.volumeDown),
      $.fnFunctionKey(keys.f12, keys.consumer.volumeUp),
    ],
  },

  virtualHidKeyboard(options={})::
    core.compact({
      country_code: core.get(options, 'country_code', 0),
      indicate_sticky_modifier_keys_state: core.get(options, 'indicate_sticky_modifier_keys_state', true),
      mouse_key_xy_scale: core.get(options, 'mouse_key_xy_scale', 100),
    }),

  countryCodes:: {
    us: 0,
    uk: 1,
    german: 3,
    french: 4,
    italian: 5,
    spanish: 6,
    japanese: 15,
    korean: 16,
  },

  build(profiles, globalOptions={})::
    {
      global: $.global(globalOptions),
      profiles: core.toArray(profiles),
    },

  buildProfile(name, rules, options={})::
    $.profile(name, {
      complex_modifications: {
        parameters: core.get(options, 'parameters', $.parameters.default),
        rules: core.toArray(rules),
      },
      devices: core.get(options, 'devices', []),
      simple_modifications: core.get(options, 'simple_modifications', []),
      fn_function_keys: core.get(options, 'fn_function_keys', []),
      virtual_hid_keyboard: core.get(options, 'virtual_hid_keyboard', $.virtualHidKeyboard()),
      selected: core.get(options, 'selected', false),
    }),

  quickProfile(name, rules)::
    $.buildProfile(name, rules, { selected: true }),
}
