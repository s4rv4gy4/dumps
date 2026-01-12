local core = import './core.libsonnet';

{
  shift: 'shift',
  control: 'control',
  option: 'option',
  command: 'command',
  fn: 'fn',
  capsLock: 'caps_lock',

  leftShift: 'left_shift',
  leftControl: 'left_control',
  leftOption: 'left_option',
  leftCommand: 'left_command',

  rightShift: 'right_shift',
  rightControl: 'right_control',
  rightOption: 'right_option',
  rightCommand: 'right_command',

  ctrl: 'control',
  opt: 'option',
  alt: 'option',
  cmd: 'command',
  lshift: 'left_shift',
  lctrl: 'left_control',
  lopt: 'left_option',
  lalt: 'left_option',
  lcmd: 'left_command',
  rshift: 'right_shift',
  rctrl: 'right_control',
  ropt: 'right_option',
  ralt: 'right_option',
  rcmd: 'right_command',
  caps: 'caps_lock',

  build(mandatory=null, optional=null)::
    core.compact({
      mandatory: if mandatory != null then core.toArray(mandatory) else null,
      optional: if optional != null then core.toArray(optional) else null,
    }),

  withAny(mandatory)::
    self.build(mandatory, ['any']),

  withCapsLock(mandatory)::
    self.build(mandatory, ['caps_lock']),

  any:: { optional: ['any'] },

  none:: {},

  shiftAny:: self.withAny(['shift']),
  ctrlAny:: self.withAny(['control']),
  optAny:: self.withAny(['option']),
  cmdAny:: self.withAny(['command']),
  fnAny:: self.withAny(['fn']),

  leftShiftAny:: self.withAny(['left_shift']),
  leftCtrlAny:: self.withAny(['left_control']),
  leftOptAny:: self.withAny(['left_option']),
  leftCmdAny:: self.withAny(['left_command']),

  rightShiftAny:: self.withAny(['right_shift']),
  rightCtrlAny:: self.withAny(['right_control']),
  rightOptAny:: self.withAny(['right_option']),
  rightCmdAny:: self.withAny(['right_command']),

  cmdShift:: self.withAny(['command', 'shift']),
  cmdOpt:: self.withAny(['command', 'option']),
  cmdCtrl:: self.withAny(['command', 'control']),
  ctrlShift:: self.withAny(['control', 'shift']),
  ctrlOpt:: self.withAny(['control', 'option']),
  optShift:: self.withAny(['option', 'shift']),
  fnShift:: self.withAny(['fn', 'shift']),
  fnCtrl:: self.withAny(['fn', 'control']),
  fnOpt:: self.withAny(['fn', 'option']),
  fnCmd:: self.withAny(['fn', 'command']),

  cmdOptShift:: self.withAny(['command', 'option', 'shift']),
  cmdCtrlShift:: self.withAny(['command', 'control', 'shift']),
  cmdCtrlOpt:: self.withAny(['command', 'control', 'option']),
  ctrlOptShift:: self.withAny(['control', 'option', 'shift']),

  hyper:: self.withAny(['command', 'control', 'option', 'shift']),
  meh:: self.withAny(['control', 'option', 'shift']),

  toMods:: {
    shift: ['shift'],
    ctrl: ['control'],
    opt: ['option'],
    cmd: ['command'],

    leftShift: ['left_shift'],
    leftCtrl: ['left_control'],
    leftOpt: ['left_option'],
    leftCmd: ['left_command'],

    rightShift: ['right_shift'],
    rightCtrl: ['right_control'],
    rightOpt: ['right_option'],
    rightCmd: ['right_command'],

    cmdShift: ['command', 'shift'],
    cmdOpt: ['command', 'option'],
    cmdCtrl: ['command', 'control'],
    ctrlShift: ['control', 'shift'],
    ctrlOpt: ['control', 'option'],
    optShift: ['option', 'shift'],

    cmdOptShift: ['command', 'option', 'shift'],
    cmdCtrlShift: ['command', 'control', 'shift'],
    cmdCtrlOpt: ['command', 'control', 'option'],
    ctrlOptShift: ['control', 'option', 'shift'],

    hyper: ['command', 'control', 'option', 'shift'],
    meh: ['control', 'option', 'shift'],

    leftHyper: ['left_command', 'left_control', 'left_option', 'left_shift'],
    leftMeh: ['left_control', 'left_option', 'left_shift'],

    rightHyper: ['right_command', 'right_control', 'right_option', 'right_shift'],
    rightMeh: ['right_control', 'right_option', 'right_shift'],
  },

  isLeft(mod)::
    std.startsWith(mod, 'left_'),

  isRight(mod)::
    std.startsWith(mod, 'right_'),

  opposite(mod)::
    if std.startsWith(mod, 'left_') then
      std.strReplace(mod, 'left_', 'right_')
    else if std.startsWith(mod, 'right_') then
      std.strReplace(mod, 'right_', 'left_')
    else
      mod,

  generic(mod)::
    local cleaned = std.strReplace(std.strReplace(mod, 'left_', ''), 'right_', '');
    cleaned,

  toLeft(mod)::
    local generic = self.generic(mod);
    'left_' + generic,

  toRight(mod)::
    local generic = self.generic(mod);
    'right_' + generic,

  all:: [
    'shift', 'control', 'option', 'command', 'fn', 'caps_lock',
    'left_shift', 'left_control', 'left_option', 'left_command',
    'right_shift', 'right_control', 'right_option', 'right_command',
  ],

  allLeft:: ['left_shift', 'left_control', 'left_option', 'left_command'],

  allRight:: ['right_shift', 'right_control', 'right_option', 'right_command'],
}
