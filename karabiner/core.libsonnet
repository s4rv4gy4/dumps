local toArray(val) = if std.isArray(val) then val else [val];
local isEmpty(val) = val == null ||
  (std.isString(val) && val == '') ||
  (std.isArray(val) && std.length(val) == 0) ||
  (std.isObject(val) && std.length(std.objectFields(val)) == 0);
local get(obj, key, default=null) = if std.objectHas(obj, key) then obj[key] else default;
local compact(obj) = std.prune(obj);
local flatten(arr) = std.flattenArrays(arr);

{
  version: '1.0.0',

  compact:: compact,

  merge(objects)::
    std.foldl(function(acc, obj) acc + obj, objects, {}),

  flatten:: flatten,

  filterNull(arr)::
    std.filter(function(x) x != null, arr),

  toArray:: toArray,

  isEmpty:: isEmpty,

  get:: get,

  complexModifications(title, rules, maintainers=[])::
    compact({
      title: title,
      maintainers: if std.length(maintainers) > 0 then maintainers else null,
      rules: toArray(rules),
    }),

  rule(description, manipulators, available_since=null)::
    local manips = toArray(manipulators);
    local flatManips = std.flatMap(function(m) if std.isArray(m) then m else [m], manips);
    compact({
      description: description,
      available_since: available_since,
      manipulators: flatManips,
    }),

  basic(from, to=null, options={})::
    compact({
      type: 'basic',
      from: from,
      to: if to != null then toArray(to) else null,
      to_if_alone: get(options, 'to_if_alone'),
      to_if_held_down: get(options, 'to_if_held_down'),
      to_after_key_up: get(options, 'to_after_key_up'),
      to_delayed_action: get(options, 'to_delayed_action'),
      conditions: get(options, 'conditions'),
      parameters: get(options, 'parameters'),
      description: get(options, 'description'),
    }),

  mouseBasic(from, to=null, options={})::
    compact({
      type: 'mouse_basic',
      from: from,
      to: if to != null then toArray(to) else null,
      conditions: get(options, 'conditions'),
    }),

  mouseMotionToScroll(from=null, options={})::
    compact({
      type: 'mouse_motion_to_scroll',
      from: from,
      conditions: get(options, 'conditions'),
      options: get(options, 'scroll_options'),
    }),

  from(key, modifiers=null, options={})::
    compact({
      key_code: key,
      modifiers: modifiers,
      simultaneous: get(options, 'simultaneous'),
      simultaneous_options: get(options, 'simultaneous_options'),
    }),

  fromConsumer(key, modifiers=null)::
    compact({
      consumer_key_code: key,
      modifiers: modifiers,
    }),

  fromMouse(button, modifiers=null)::
    compact({
      pointing_button: button,
      modifiers: modifiers,
    }),

  fromAny(type)::
    compact({
      any: type,
    }),

  fromSimultaneous(keys, options={})::
    local keyList = toArray(keys);
    compact({
      simultaneous: [
        if std.isString(k) then { key_code: k } else k
        for k in keyList
      ],
      simultaneous_options: if !isEmpty(options) then compact({
        key_down_order: get(options, 'key_down_order'),
        key_up_order: get(options, 'key_up_order'),
        detect_key_down_uninterruptedly: get(options, 'detect_key_down_uninterruptedly'),
        to_after_key_up: get(options, 'to_after_key_up'),
      }) else null,
      modifiers: get(options, 'modifiers'),
    }),

  modifiers(mandatory=null, optional=null)::
    compact({
      mandatory: if mandatory != null then toArray(mandatory) else null,
      optional: if optional != null then toArray(optional) else null,
    }),

  mods:: {
    any: { optional: ['any'] },
    anyMandatory: { mandatory: ['any'] },

    shift: { mandatory: ['shift'] },
    leftShift: { mandatory: ['left_shift'] },
    rightShift: { mandatory: ['right_shift'] },
    shiftOptional: { mandatory: ['shift'], optional: ['caps_lock'] },

    ctrl: { mandatory: ['control'] },
    leftCtrl: { mandatory: ['left_control'] },
    rightCtrl: { mandatory: ['right_control'] },

    opt: { mandatory: ['option'] },
    leftOpt: { mandatory: ['left_option'] },
    rightOpt: { mandatory: ['right_option'] },

    cmd: { mandatory: ['command'] },
    leftCmd: { mandatory: ['left_command'] },
    rightCmd: { mandatory: ['right_command'] },

    cmdShift: { mandatory: ['command', 'shift'] },
    cmdOpt: { mandatory: ['command', 'option'] },
    cmdCtrl: { mandatory: ['command', 'control'] },
    ctrlShift: { mandatory: ['control', 'shift'] },
    ctrlOpt: { mandatory: ['control', 'option'] },
    optShift: { mandatory: ['option', 'shift'] },

    hyper: { mandatory: ['command', 'control', 'option', 'shift'] },
    meh: { mandatory: ['control', 'option', 'shift'] },

    withAny(mods): { mandatory: mods, optional: ['any'] },
    withCapsLock(mods): { mandatory: mods, optional: ['caps_lock'] },
  },

  to(key, modifiers=null, options={})::
    compact({
      key_code: key,
      modifiers: if modifiers != null then toArray(modifiers) else null,
      lazy: get(options, 'lazy'),
      repeat: get(options, 'repeat'),
      halt: get(options, 'halt'),
      hold_down_milliseconds: get(options, 'hold_down_milliseconds'),
    }),

  toConsumer(key)::
    compact({
      consumer_key_code: key,
    }),

  toShell(command)::
    compact({
      shell_command: command,
    }),

  toInputSource(source)::
    compact({
      select_input_source: source,
    }),

  toVar(name, value)::
    compact({
      set_variable: {
        name: name,
        value: value,
      },
    }),

  toNotify(id, text)::
    compact({
      set_notification_message: {
        id: id,
        text: text,
      },
    }),

  toMouse(options)::
    compact({
      mouse_key: options,
    }),

  toSticky(modifier, state='toggle')::
    compact({
      sticky_modifier: {
        [modifier]: state,
      },
    }),

  toSoftwareFunction(func)::
    compact({
      software_function: func,
    }),

  toApp(bundle_id)::
    $.toSoftwareFunction({
      open_application: {
        bundle_identifier: bundle_id,
      },
    }),

  toMousePosition(x, y, screen=0)::
    $.toSoftwareFunction({
      set_mouse_cursor_position: {
        x: x,
        y: y,
        screen: screen,
      },
    }),

  toSleep()::
    $.toSoftwareFunction({
      iokit_power_management_sleep_system: {},
    }),

  toDoubleClick(button='left')::
    $.toSoftwareFunction({
      cg_event_double_click: {
        button: button,
      },
    }),

  params:: {
    simultaneousThreshold(ms): {
      'basic.simultaneous_threshold_milliseconds': ms,
    },

    toIfAloneTimeout(ms): {
      'basic.to_if_alone_timeout_milliseconds': ms,
    },

    toIfHeldDownThreshold(ms): {
      'basic.to_if_held_down_threshold_milliseconds': ms,
    },

    toDelayedActionDelay(ms): {
      'basic.to_delayed_action_delay_milliseconds': ms,
    },
  },
}
