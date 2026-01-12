local core = import './core.libsonnet';

{
  app(bundle_ids, file_paths=null)::
    core.compact({
      type: 'frontmost_application_if',
      bundle_identifiers: core.toArray(bundle_ids),
      file_paths: if file_paths != null then core.toArray(file_paths) else null,
    }),

  appUnless(bundle_ids, file_paths=null)::
    core.compact({
      type: 'frontmost_application_unless',
      bundle_identifiers: core.toArray(bundle_ids),
      file_paths: if file_paths != null then core.toArray(file_paths) else null,
    }),

  frontmostApp(bundle_ids, file_paths=null):: self.app(bundle_ids, file_paths),
  frontmostAppUnless(bundle_ids, file_paths=null):: self.appUnless(bundle_ids, file_paths),

  device(identifiers)::
    core.compact({
      type: 'device_if',
      identifiers: core.toArray(identifiers),
    }),

  deviceUnless(identifiers)::
    core.compact({
      type: 'device_unless',
      identifiers: core.toArray(identifiers),
    }),

  deviceExists(identifiers)::
    core.compact({
      type: 'device_exists_if',
      identifiers: core.toArray(identifiers),
    }),

  deviceExistsUnless(identifiers)::
    core.compact({
      type: 'device_exists_unless',
      identifiers: core.toArray(identifiers),
    }),

  deviceId(vendor_id=null, product_id=null, location_id=null, is_keyboard=null, is_pointing_device=null, is_touch_bar=null, is_built_in_keyboard=null)::
    core.compact({
      vendor_id: vendor_id,
      product_id: product_id,
      location_id: location_id,
      is_keyboard: is_keyboard,
      is_pointing_device: is_pointing_device,
      is_touch_bar: is_touch_bar,
      is_built_in_keyboard: is_built_in_keyboard,
    }),

  keyboardType(types)::
    core.compact({
      type: 'keyboard_type_if',
      keyboard_types: core.toArray(types),
    }),

  keyboardTypeUnless(types)::
    core.compact({
      type: 'keyboard_type_unless',
      keyboard_types: core.toArray(types),
    }),

  keyboardTypes:: {
    ansi: 'ansi',
    iso: 'iso',
    jis: 'jis',
  },

  inputSource(sources)::
    core.compact({
      type: 'input_source_if',
      input_sources: core.toArray(sources),
    }),

  inputSourceUnless(sources)::
    core.compact({
      type: 'input_source_unless',
      input_sources: core.toArray(sources),
    }),

  inputSourceId(language=null, input_source_id=null, input_mode_id=null)::
    core.compact({
      language: language,
      input_source_id: input_source_id,
      input_mode_id: input_mode_id,
    }),

  varIf(name, value=1)::
    {
      type: 'variable_if',
      name: name,
      value: value,
    },

  varUnless(name, value=1)::
    {
      type: 'variable_unless',
      name: name,
      value: value,
    },

  variable(name, value=1):: self.varIf(name, value),
  variableUnless(name, value=1):: self.varUnless(name, value),

  expression(expr)::
    {
      type: 'expression_if',
      expression: expr,
    },

  expressionUnless(expr)::
    {
      type: 'expression_unless',
      expression: expr,
    },

  eventChanged(value=true)::
    {
      type: 'event_changed_if',
      value: value,
    },

  eventChangedUnless(value=true)::
    {
      type: 'event_changed_unless',
      value: value,
    },

  all(conditions)::
    core.flatten(core.toArray(conditions)),

  layer(name, value=1)::
    self.varIf(name, value),

  layerUnless(name, value=1)::
    self.varUnless(name, value),

  apps:: {
    terminal: '^com\\.apple\\.Terminal$',
    iterm: '^com\\.googlecode\\.iterm2$',
    alacritty: '^(io|org)\\.alacritty$',
    kitty: '^net\\.kovidgoyal\\.kitty$',
    warp: '^dev\\.warp\\.Warp-Stable$',
    hyper: '^co\\.zeit\\.hyper$',

    safari: '^com\\.apple\\.Safari$',
    chrome: '^com\\.google\\.Chrome$',
    firefox: '^org\\.mozilla\\.firefox$',
    edge: '^com\\.microsoft\\.edgemac$',
    brave: '^com\\.brave\\.Browser$',
    arc: '^company\\.thebrowser\\.Browser$',

    vscode: '^com\\.microsoft\\.VSCode$',
    cursor: '^com\\.todesktop\\.230313mzl4w4u92$',
    sublime: '^com\\.sublimetext\\.',
    atom: '^com\\.github\\.atom$',
    vim: '^org\\.vim\\.',
    neovim: '^com\\.qvacua\\.VimR$',
    emacs: '^org\\.gnu\\.Emacs$',
    xcode: '^com\\.apple\\.dt\\.Xcode$',
    intellij: '^com\\.jetbrains\\.intellij$',
    webstorm: '^com\\.jetbrains\\.WebStorm$',
    pycharm: '^com\\.jetbrains\\.pycharm$',
    goland: '^com\\.jetbrains\\.goland$',
    rider: '^com\\.jetbrains\\.rider$',
    androidStudio: '^com\\.google\\.android\\.studio$',

    slack: '^com\\.tinyspeck\\.slackmacgap$',
    discord: '^com\\.hnc\\.Discord$',
    teams: '^com\\.microsoft\\.teams2?$',
    zoom: '^us\\.zoom\\.xos$',
    messages: '^com\\.apple\\.MobileSMS$',
    mail: '^com\\.apple\\.mail$',

    finder: '^com\\.apple\\.finder$',
    notes: '^com\\.apple\\.Notes$',
    reminders: '^com\\.apple\\.reminders$',
    calendar: '^com\\.apple\\.iCal$',
    notion: '^notion\\.id$',
    obsidian: '^md\\.obsidian$',
    bear: '^net\\.shinyfrog\\.bear$',

    spotify: '^com\\.spotify\\.client$',
    music: '^com\\.apple\\.Music$',
    vlc: '^org\\.videolan\\.vlc$',
    photos: '^com\\.apple\\.Photos$',

    figma: '^com\\.figma\\.Desktop$',
    sketch: '^com\\.bohemiancoding\\.sketch3$',
    photoshop: '^com\\.adobe\\.Photoshop',
    illustrator: '^com\\.adobe\\.Illustrator',

    activityMonitor: '^com\\.apple\\.ActivityMonitor$',
    systemPreferences: '^com\\.apple\\.systempreferences$',
    systemSettings: '^com\\.apple\\.systempreferences$',
    preview: '^com\\.apple\\.Preview$',
    keyboardMaestro: '^com\\.stairways\\.keyboardmaestro',
    alfred: '^com\\.runningwithcrayons\\.Alfred',
    raycast: '^com\\.raycast\\.macos$',

    parallels: '^com\\.parallels\\.desktop',
    vmware: '^com\\.vmware\\.fusion$',
    virtualbox: '^org\\.virtualbox\\.app\\.VirtualBoxVM$',
    rdp: '^com\\.microsoft\\.rdc',
    citrix: '^com\\.citrix\\.',

    steam: '^com\\.valvesoftware\\.steam$',
  },

  devices:: {
    apple: $.deviceId(vendor_id=1452),
    appleInternal: $.deviceId(vendor_id=1452, is_built_in_keyboard=true),
    appleExternal: $.deviceId(vendor_id=1452, is_built_in_keyboard=false),

    logitech: $.deviceId(vendor_id=1133),
    microsoft: $.deviceId(vendor_id=1118),
    razer: $.deviceId(vendor_id=5426),
    corsair: $.deviceId(vendor_id=6940),
    keychron: $.deviceId(vendor_id=1452),
    hhkb: $.deviceId(vendor_id=1278),
    realforce: $.deviceId(vendor_id=2131),
    ducky: $.deviceId(vendor_id=1241),
    das: $.deviceId(vendor_id=9456),
    filco: $.deviceId(vendor_id=1241),

    builtIn: $.deviceId(is_built_in_keyboard=true),
    external: $.deviceId(is_built_in_keyboard=false),

    keyboard: $.deviceId(is_keyboard=true),
    mouse: $.deviceId(is_pointing_device=true),
    touchBar: $.deviceId(is_touch_bar=true),
  },

  inputSources:: {
    english: $.inputSourceId(language='en'),
    japanese: $.inputSourceId(language='ja'),
    korean: $.inputSourceId(language='ko'),
    chinese: $.inputSourceId(language='zh'),
    german: $.inputSourceId(language='de'),
    french: $.inputSourceId(language='fr'),
    spanish: $.inputSourceId(language='es'),
    russian: $.inputSourceId(language='ru'),
  },
}
