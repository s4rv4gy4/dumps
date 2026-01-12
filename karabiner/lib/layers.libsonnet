local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';

{
  layer(name, trigger, mappings, options={})::
    local triggerKey = if std.isString(trigger) then trigger else trigger.key;
    local triggerMods = if std.isObject(trigger) && std.objectHas(trigger, 'mods') then trigger.mods else null;
    local tapKey = core.get(options, 'tap');
    local notification = core.get(options, 'notification');

    {
      name: name,
      trigger: triggerKey,
      triggerMods: triggerMods,
      mappings: mappings,
      tap: tapKey,
      notification: notification,

      activator()::
        local toEvents = [core.toVar(name, 1)] +
          (if notification != null then [core.toNotify(name, notification)] else []);
        local afterKeyUp = [core.toVar(name, 0)] +
          (if notification != null then [core.toNotify(name, '')] else []);

        core.basic(
          core.from(triggerKey, if triggerMods != null then triggerMods else mods.any),
          toEvents,
          {
            to_if_alone: if tapKey != null then [core.to(tapKey)] else null,
            to_after_key_up: afterKeyUp,
          }
        ),

      manipulators()::
        [self.activator()] + [
          core.basic(
            core.from(m.from, core.get(m, 'fromMods', mods.any)),
            if std.isString(m.to) then core.to(m.to, core.get(m, 'toMods'))
            else if std.isArray(m.to) then m.to
            else m.to,
            { conditions: [cond.varIf(name, 1)] }
          )
          for m in mappings
        ],
    },

  sublayer(parentLayer, name, trigger, mappings, options={})::
    local fullName = parentLayer + '_' + name;
    self.layer(fullName, trigger, mappings, options) + {
      parentLayer: parentLayer,

      activator()::
        local triggerKey = if std.isString(trigger) then trigger else trigger.key;
        local notification = core.get(options, 'notification');
        local toEvents = [core.toVar(fullName, 1)] +
          (if notification != null then [core.toNotify(fullName, notification)] else []);
        local afterKeyUp = [core.toVar(fullName, 0)] +
          (if notification != null then [core.toNotify(fullName, '')] else []);

        core.basic(
          core.from(triggerKey, mods.any),
          toEvents,
          {
            to_after_key_up: afterKeyUp,
            conditions: [cond.varIf(parentLayer, 1)],
          }
        ),

      manipulators()::
        [self.activator()] + [
          core.basic(
            core.from(m.from, core.get(m, 'fromMods', mods.any)),
            if std.isString(m.to) then core.to(m.to, core.get(m, 'toMods'))
            else if std.isArray(m.to) then m.to
            else m.to,
            { conditions: [cond.varIf(parentLayer, 1), cond.varIf(fullName, 1)] }
          )
          for m in mappings
        ],
    },

  build:: {
    viNavigation(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.h, to: keys.left },
        { from: keys.j, to: keys.down },
        { from: keys.k, to: keys.up },
        { from: keys.l, to: keys.right },
        { from: keys.n0, to: keys.left, toMods: mods.toMods.cmd },
        { from: keys.n4, to: keys.right, toMods: mods.toMods.cmd },
        { from: keys.b, to: keys.left, toMods: mods.toMods.opt },
        { from: keys.w, to: keys.right, toMods: mods.toMods.opt },
        { from: keys.u, to: keys.pageUp },
        { from: keys.d, to: keys.pageDown },
        { from: keys.g, to: keys.home },
        { from: keys.semicolon, to: keys.end },  // G in vi is gg for top, G for bottom
      ], options),

    ijklNavigation(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.i, to: keys.up },
        { from: keys.j, to: keys.left },
        { from: keys.k, to: keys.down },
        { from: keys.l, to: keys.right },
        { from: keys.u, to: keys.home },
        { from: keys.o, to: keys.end },
        { from: keys.h, to: keys.pageUp },
        { from: keys.n, to: keys.pageDown },
      ], options),

    wasdNavigation(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.w, to: keys.up },
        { from: keys.a, to: keys.left },
        { from: keys.s, to: keys.down },
        { from: keys.d, to: keys.right },
        { from: keys.q, to: keys.home },
        { from: keys.e, to: keys.end },
        { from: keys.r, to: keys.pageUp },
        { from: keys.f, to: keys.pageDown },
      ], options),

    functionKeys(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.n1, to: keys.f1 },
        { from: keys.n2, to: keys.f2 },
        { from: keys.n3, to: keys.f3 },
        { from: keys.n4, to: keys.f4 },
        { from: keys.n5, to: keys.f5 },
        { from: keys.n6, to: keys.f6 },
        { from: keys.n7, to: keys.f7 },
        { from: keys.n8, to: keys.f8 },
        { from: keys.n9, to: keys.f9 },
        { from: keys.n0, to: keys.f10 },
        { from: keys.hyphen, to: keys.f11 },
        { from: keys.equalSign, to: keys.f12 },
      ], options),

    mediaControls(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.p, to: [core.toConsumer(keys.consumer.playPause)] },
        { from: keys.openBracket, to: [core.toConsumer(keys.consumer.prevTrack)] },
        { from: keys.closeBracket, to: [core.toConsumer(keys.consumer.nextTrack)] },
        { from: keys.hyphen, to: [core.toConsumer(keys.consumer.volumeDown)] },
        { from: keys.equalSign, to: [core.toConsumer(keys.consumer.volumeUp)] },
        { from: keys.m, to: [core.toConsumer(keys.consumer.mute)] },
        { from: keys.comma, to: [core.toConsumer(keys.consumer.brightnessDown)] },
        { from: keys.period, to: [core.toConsumer(keys.consumer.brightnessUp)] },
      ], options),

    symbolLayer(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.a, to: keys.openBracket, toMods: mods.toMods.shift },   // {
        { from: keys.s, to: keys.closeBracket, toMods: mods.toMods.shift },  // }
        { from: keys.d, to: keys.n9, toMods: mods.toMods.shift },            // (
        { from: keys.f, to: keys.n0, toMods: mods.toMods.shift },            // )
        { from: keys.q, to: keys.openBracket },                               // [
        { from: keys.w, to: keys.closeBracket },                              // ]
        { from: keys.e, to: keys.comma, toMods: mods.toMods.shift },         // <
        { from: keys.r, to: keys.period, toMods: mods.toMods.shift },        // >
        { from: keys.j, to: keys.hyphen },                                    // -
        { from: keys.k, to: keys.equalSign },                                 // =
        { from: keys.l, to: keys.equalSign, toMods: mods.toMods.shift },     // +
        { from: keys.semicolon, to: keys.backslash, toMods: mods.toMods.shift }, // |
        { from: keys.u, to: keys.n1, toMods: mods.toMods.shift },            // !
        { from: keys.i, to: keys.n7, toMods: mods.toMods.shift },            // &
        { from: keys.o, to: keys.backslash },                                 // \
        { from: keys.p, to: keys.grave },                                     // `
      ], options),

    numpad(name, trigger, options={})::
      $.layer(name, trigger, [
        { from: keys.m, to: keys.n0 },
        { from: keys.j, to: keys.n1 },
        { from: keys.k, to: keys.n2 },
        { from: keys.l, to: keys.n3 },
        { from: keys.u, to: keys.n4 },
        { from: keys.i, to: keys.n5 },
        { from: keys.o, to: keys.n6 },
        { from: keys.n7, to: keys.n7 },
        { from: keys.n8, to: keys.n8 },
        { from: keys.n9, to: keys.n9 },
        { from: keys.period, to: keys.period },
        { from: keys.comma, to: keys.comma },
        { from: keys.p, to: keys.hyphen },
        { from: keys.semicolon, to: keys.equalSign, toMods: mods.toMods.shift },
      ], options),
  },

  combine(layers)::
    core.flatten([l.manipulators() for l in layers]),

  simultaneousLayer(name, keys, mappings, options={})::
    local notification = core.get(options, 'notification');
    local threshold = core.get(options, 'threshold', 500);

    {
      name: name,
      keys: keys,
      mappings: mappings,

      activator()::
        local toEvents = [core.toVar(name, 1)] +
          (if notification != null then [core.toNotify(name, notification)] else []);
        local afterKeyUp = [core.toVar(name, 0)] +
          (if notification != null then [core.toNotify(name, '')] else []);

        core.basic(
          core.fromSimultaneous(keys, {
            key_down_order: 'strict',
            key_up_order: 'strict_inverse',
            to_after_key_up: afterKeyUp,
            modifiers: mods.any,
          }),
          toEvents,
          { parameters: core.params.simultaneousThreshold(threshold) }
        ),

      manipulators()::
        [self.activator()] + [
          core.basic(
            core.from(m.from, core.get(m, 'fromMods', mods.any)),
            if std.isString(m.to) then core.to(m.to, core.get(m, 'toMods'))
            else if std.isArray(m.to) then m.to
            else m.to,
            { conditions: [cond.varIf(name, 1)] }
          )
          for m in mappings
        ],
    },

  stickyLayer(name, trigger, mappings, options={})::
    local notification = core.get(options, 'notification');
    local varName = name + '_active';

    {
      name: name,
      trigger: trigger,
      mappings: mappings,

      toggle()::
        [
          core.basic(
            core.from(trigger, mods.any),
            [core.toVar(varName, 0)] +
              (if notification != null then [core.toNotify(name, '')] else []),
            { conditions: [cond.varIf(varName, 1)] }
          ),
          core.basic(
            core.from(trigger, mods.any),
            [core.toVar(varName, 1)] +
              (if notification != null then [core.toNotify(name, notification)] else []),
            { conditions: [cond.varUnless(varName, 1)] }
          ),
        ],

      manipulators()::
        self.toggle() + [
          core.basic(
            core.from(m.from, core.get(m, 'fromMods', mods.any)),
            if std.isString(m.to) then core.to(m.to, core.get(m, 'toMods'))
            else if std.isArray(m.to) then m.to
            else m.to,
            { conditions: [cond.varIf(varName, 1)] }
          )
          for m in mappings
        ],
    },
}
