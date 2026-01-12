local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local modifiers = import './modifiers.libsonnet';
local conditions = import './conditions.libsonnet';
local manipulators = import './manipulators.libsonnet';
local layers = import './layers.libsonnet';
local applications = import './applications.libsonnet';
local devices = import './devices.libsonnet';
local templates = import './templates.libsonnet';
local presets = import './presets.libsonnet';
local rules = import './rules.libsonnet';
local config = import './config.libsonnet';

{
  version: '1.0.0',

  core:: core,
  keys:: keys,
  modifiers:: modifiers,
  mods:: modifiers,
  conditions:: conditions,
  cond:: conditions,
  manipulators:: manipulators,
  man:: manipulators,
  layers:: layers,
  applications:: applications,
  apps:: applications,
  devices:: devices,
  templates:: templates,
  tpl:: templates,
  presets:: presets,
  rules:: rules,
  config:: config,

  complexModifications(title, rules, maintainers=[])::
    core.complexModifications(title, rules, maintainers),

  rule(description, manipulators, available_since=null)::
    core.rule(description, manipulators, available_since),

  basic(from, to=null, options={})::
    core.basic(from, to, options),

  from(key, modifiers=null, options={})::
    core.from(key, modifiers, options),

  to(key, modifiers=null, options={})::
    core.to(key, modifiers, options),

  remap(fromKey, toKey, fromMods=null, toMods=null, conditions=null)::
    manipulators.remap(fromKey, toKey, fromMods, toMods, conditions),

  remapAny(fromKey, toKey, toMods=null, conditions=null)::
    manipulators.remapAny(fromKey, toKey, toMods, conditions),

  dualRole(key, tapKey, holdKey, holdMods=null, conditions=null)::
    manipulators.dualRole(key, tapKey, holdKey, holdMods, conditions),

  layerToggle(key, layerName, conditions=null)::
    manipulators.layerToggle(key, layerName, conditions),

  layerMapping(layerName, fromKey, toKey, toMods=null, fromMods=null)::
    manipulators.layerMapping(layerName, fromKey, toKey, toMods, fromMods),

  toShellCommand(fromKey, command, fromMods=null, conditions=null)::
    manipulators.toShellCommand(fromKey, command, fromMods, conditions),

  toOpenApp(fromKey, bundleId, fromMods=null, conditions=null)::
    manipulators.toOpenApp(fromKey, bundleId, fromMods, conditions),

  toShell(command):: core.toShell(command),
  toVar(name, value):: core.toVar(name, value),
  toNotify(id, text):: core.toNotify(id, text),
  toApp(bundleId):: core.toApp(bundleId),
  toConsumer(key):: core.toConsumer(key),
  toMouse(options):: core.toMouse(options),
  toSticky(modifier, state='toggle'):: core.toSticky(modifier, state),
  toInputSource(source):: core.toInputSource(source),

  app(bundleIds, filePaths=null):: conditions.app(bundleIds, filePaths),
  appUnless(bundleIds, filePaths=null):: conditions.appUnless(bundleIds, filePaths),
  device(identifiers):: conditions.device(identifiers),
  deviceUnless(identifiers):: conditions.deviceUnless(identifiers),
  varIf(name, value=1):: conditions.varIf(name, value),
  varUnless(name, value=1):: conditions.varUnless(name, value),
  inputSource(sources):: conditions.inputSource(sources),
  keyboardType(types):: conditions.keyboardType(types),

  hyperKey(triggerKey=null, tapKey=null)::
    local trigger = if triggerKey != null then triggerKey else keys.capsLock;
    local tap = if tapKey != null then tapKey else keys.escape;
    core.basic(
      core.from(trigger, modifiers.any),
      core.to(keys.leftShift, modifiers.toMods.leftMeh),
      { to_if_alone: [core.to(tap)] }
    ),

  capsEscCtrl()::
    manipulators.capsToEscCtrl(),

  viLayer(triggerKey=null)::
    local trigger = if triggerKey != null then triggerKey else keys.capsLock;
    templates.navigation.viCapsLock(),

  appLauncher(key, bundleId, mods=null)::
    applications.launcher.open(key, bundleId, mods),

  preset(name)::
    if std.objectHasAll(presets, name) then
      presets.generate(presets[name])
    else
      error 'Unknown preset: ' + name,

  listPresets():: presets.list,

  buildConfig(profiles, globalOptions={})::
    config.build(profiles, globalOptions),

  buildProfile(name, rules, options={})::
    config.buildProfile(name, rules, options),

  quickProfile(name, rules)::
    config.quickProfile(name, rules),
}
