local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';

{
  simple(description, manipulators)::
    core.rule(description, manipulators),

  versioned(description, manipulators, version)::
    core.rule(description, manipulators, version),

  fromMapping(mappings)::
    [
      core.rule(m.description, m.manipulators)
      for m in mappings
    ],

  combine(rules)::
    core.flatten(rules),

  merge(description, rules)::
    core.rule(
      description,
      core.flatten([r.manipulators for r in rules])
    ),

  forApp(description, bundleId, manipulators)::
    core.rule(description, [
      m + { conditions: [cond.app(bundleId)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ]),

  exceptApp(description, bundleId, manipulators)::
    core.rule(description, [
      m + { conditions: [cond.appUnless(bundleId)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ]),

  forDevice(description, deviceId, manipulators)::
    core.rule(description, [
      m + { conditions: [cond.device(deviceId)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ]),

  exceptDevice(description, deviceId, manipulators)::
    core.rule(description, [
      m + { conditions: [cond.deviceUnless(deviceId)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ]),

  forKeyboardType(description, keyboardType, manipulators)::
    core.rule(description, [
      m + { conditions: [cond.keyboardType(keyboardType)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ]),

  forInputSource(description, inputSource, manipulators)::
    core.rule(description, [
      m + { conditions: [cond.inputSource(inputSource)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ]),

  group(name, rules)::
    {
      name: name,
      rules: rules,

      all():: self.rules,

      get(index):: self.rules[index],

      add(rule):: self + { rules: self.rules + [rule] },

      filter(pattern)::
        std.filter(function(r) std.findSubstr(pattern, r.description) != [], self.rules),
    },

  template(baseDescription, baseManipulators)::
    {
      description: baseDescription,
      manipulators: baseManipulators,

      withConditions(conditions)::
        core.rule(self.description, [
          m + { conditions: core.toArray(conditions) + core.get(m, 'conditions', []) }
          for m in self.manipulators
        ]),

      forApp(bundleId)::
        self.withConditions([cond.app(bundleId)]),

      forDevice(deviceId)::
        self.withConditions([cond.device(deviceId)]),

      withDescription(newDescription)::
        self + { description: newDescription },

      build()::
        core.rule(self.description, self.manipulators),
    },

  validate(rule)::
    local hasDescription = std.objectHas(rule, 'description') && std.isString(rule.description);
    local hasManipulators = std.objectHas(rule, 'manipulators') && std.isArray(rule.manipulators);
    local manipulatorsValid = std.all([
      std.objectHas(m, 'type') && std.objectHas(m, 'from')
      for m in core.get(rule, 'manipulators', [])
    ]);

    {
      valid: hasDescription && hasManipulators && manipulatorsValid,
      errors:
        (if !hasDescription then ['Missing or invalid description'] else []) +
        (if !hasManipulators then ['Missing or invalid manipulators array'] else []) +
        (if !manipulatorsValid then ['One or more manipulators missing type or from'] else []),
    },

  countManipulators(rule)::
    std.length(core.get(rule, 'manipulators', [])),

  extractKeyCodes(rule)::
    local manipulators = core.get(rule, 'manipulators', []);
    local fromKeys = [
      core.get(m.from, 'key_code')
      for m in manipulators
      if std.objectHas(m, 'from') && std.objectHas(m.from, 'key_code')
    ];
    local toKeys = core.flatten([
      [core.get(t, 'key_code') for t in core.toArray(core.get(m, 'to', [])) if std.objectHas(t, 'key_code')]
      for m in manipulators
    ]);
    std.set(fromKeys + toKeys),

  usesKey(rule, keyCode)::
    std.member(self.extractKeyCodes(rule), keyCode),

  extractConditions(rule)::
    local manipulators = core.get(rule, 'manipulators', []);
    core.flatten([
      core.get(m, 'conditions', [])
      for m in manipulators
    ]),

  isAppSpecific(rule)::
    local conditions = self.extractConditions(rule);
    std.any([
      std.member(['frontmost_application_if', 'frontmost_application_unless'], c.type)
      for c in conditions
    ]),

  isDeviceSpecific(rule)::
    local conditions = self.extractConditions(rule);
    std.any([
      std.member(['device_if', 'device_unless', 'device_exists_if', 'device_exists_unless'], c.type)
      for c in conditions
    ]),
}
