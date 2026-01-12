local core = import './core.libsonnet';
local keys = import './keys.libsonnet';
local mods = import './modifiers.libsonnet';
local cond = import './conditions.libsonnet';

{
  bundles:: cond.apps,

  inApp(bundleId):: cond.app(bundleId),
  notInApp(bundleId):: cond.appUnless(bundleId),

  inTerminal:: cond.app([
    cond.apps.terminal,
    cond.apps.iterm,
    cond.apps.alacritty,
    cond.apps.kitty,
    cond.apps.warp,
    cond.apps.hyper,
  ]),

  notInTerminal:: cond.appUnless([
    cond.apps.terminal,
    cond.apps.iterm,
    cond.apps.alacritty,
    cond.apps.kitty,
    cond.apps.warp,
    cond.apps.hyper,
  ]),

  inBrowser:: cond.app([
    cond.apps.safari,
    cond.apps.chrome,
    cond.apps.firefox,
    cond.apps.edge,
    cond.apps.brave,
    cond.apps.arc,
  ]),

  notInBrowser:: cond.appUnless([
    cond.apps.safari,
    cond.apps.chrome,
    cond.apps.firefox,
    cond.apps.edge,
    cond.apps.brave,
    cond.apps.arc,
  ]),

  inEditor:: cond.app([
    cond.apps.vscode,
    cond.apps.cursor,
    cond.apps.sublime,
    cond.apps.vim,
    cond.apps.neovim,
    cond.apps.emacs,
    cond.apps.xcode,
    cond.apps.intellij,
    cond.apps.webstorm,
    cond.apps.pycharm,
    cond.apps.goland,
    cond.apps.rider,
    cond.apps.androidStudio,
  ]),

  notInEditor:: cond.appUnless([
    cond.apps.vscode,
    cond.apps.cursor,
    cond.apps.sublime,
    cond.apps.vim,
    cond.apps.neovim,
    cond.apps.emacs,
    cond.apps.xcode,
    cond.apps.intellij,
    cond.apps.webstorm,
    cond.apps.pycharm,
    cond.apps.goland,
    cond.apps.rider,
    cond.apps.androidStudio,
  ]),

  inVirtualMachine:: cond.app([
    cond.apps.parallels,
    cond.apps.vmware,
    cond.apps.virtualbox,
    cond.apps.rdp,
    cond.apps.citrix,
  ]),

  notInVirtualMachine:: cond.appUnless([
    cond.apps.parallels,
    cond.apps.vmware,
    cond.apps.virtualbox,
    cond.apps.rdp,
    cond.apps.citrix,
  ]),

  forApp(bundleId, manipulators)::
    [
      m + { conditions: [cond.app(bundleId)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ],

  exceptApp(bundleId, manipulators)::
    [
      m + { conditions: [cond.appUnless(bundleId)] + core.get(m, 'conditions', []) }
      for m in core.toArray(manipulators)
    ],

  configs:: {
    terminal:: {
      optionAsEscape(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.terminal,
          cond.apps.iterm,
          cond.apps.alacritty,
          cond.apps.kitty,
        ];
        [
          core.basic(
            core.from(key, mods.leftOptAny),
            [core.to(keys.escape), core.to(key)],
            { conditions: [cond.app(apps)] }
          )
          for key in keys.letters
        ],

      swapCmdCtrl(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.terminal,
          cond.apps.iterm,
        ];
        [
          core.basic(
            core.from(keys.c, mods.cmdAny),
            core.to(keys.c, mods.toMods.ctrl),
            { conditions: [cond.app(apps)] }
          ),
          core.basic(
            core.from(keys.v, mods.cmdAny),
            core.to(keys.v, mods.toMods.ctrl),
            { conditions: [cond.app(apps)] }
          ),
          core.basic(
            core.from(keys.c, mods.ctrlAny),
            core.to(keys.c, mods.toMods.cmd),
            { conditions: [cond.app(apps)] }
          ),
          core.basic(
            core.from(keys.v, mods.ctrlAny),
            core.to(keys.v, mods.toMods.cmd),
            { conditions: [cond.app(apps)] }
          ),
        ],
    },

    browser:: {
      tabNumbers(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.chrome,
          cond.apps.firefox,
          cond.apps.safari,
          cond.apps.edge,
          cond.apps.brave,
          cond.apps.arc,
        ];
        [
          core.basic(
            core.from(std.toString(n), mods.cmdAny),
            core.to(std.toString(n), mods.toMods.cmd),
            { conditions: [cond.app(apps)] }
          )
          for n in std.range(1, 9)
        ],

      vimTabs(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.chrome,
          cond.apps.firefox,
          cond.apps.safari,
        ];
        [
          core.basic(
            core.from(keys.h, mods.ctrlAny),
            core.to(keys.openBracket, mods.toMods.cmdShift),
            { conditions: [cond.app(apps)] }
          ),
          core.basic(
            core.from(keys.l, mods.ctrlAny),
            core.to(keys.closeBracket, mods.toMods.cmdShift),
            { conditions: [cond.app(apps)] }
          ),
        ],
    },

    editor:: {
      jetbrainsFunctionKeys(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.intellij,
          cond.apps.webstorm,
          cond.apps.pycharm,
          cond.apps.goland,
          cond.apps.rider,
          cond.apps.androidStudio,
        ];
        [
          core.basic(
            core.from(keys.f1, mods.any),
            core.to(keys.f1),
            { conditions: [cond.app(apps)] }
          ),
        ],

      vscodeEnhancements(bundleIds=null)::
        local apps = if bundleIds != null then bundleIds else [
          cond.apps.vscode,
          cond.apps.cursor,
        ];
        [
          core.basic(
            core.from(keys.s, mods.cmdAny),
            core.to(keys.s, mods.toMods.cmd),
            { conditions: [cond.app(apps), cond.varIf('vscode_cmd_k', 1)] }
          ),
        ],
    },

    communication:: {
      slackEnhancements(bundleId=null)::
        local app = if bundleId != null then bundleId else cond.apps.slack;
        [
          core.basic(
            core.from(keys.k, mods.cmdAny),
            core.to(keys.k, mods.toMods.cmd),
            { conditions: [cond.app(app)] }
          ),
        ],

      zoomMute(key, fromMods=null, bundleId=null)::
        local app = if bundleId != null then bundleId else cond.apps.zoom;
        core.basic(
          core.from(key, fromMods),
          core.to(keys.a, mods.toMods.cmdShift),
          { conditions: [cond.app(app)] }
        ),

      teamsMute(key, fromMods=null, bundleId=null)::
        local app = if bundleId != null then bundleId else cond.apps.teams;
        core.basic(
          core.from(key, fromMods),
          core.to(keys.m, mods.toMods.cmdShift),
          { conditions: [cond.app(app)] }
        ),
    },

    finder:: {
      openTerminal(key=keys.t, fromMods=null)::
        core.basic(
          core.from(key, if fromMods != null then fromMods else mods.cmdAny),
          core.toShell('open -a Terminal "$(osascript -e \'tell app "Finder" to POSIX path of (insertion location as alias)\')"'),
          { conditions: [cond.app(cond.apps.finder)] }
        ),

      toggleHidden(key=keys.period, fromMods=null)::
        core.basic(
          core.from(key, if fromMods != null then fromMods else mods.cmdShift),
          core.to(keys.period, mods.toMods.cmdShift),
          { conditions: [cond.app(cond.apps.finder)] }
        ),
    },
  },

  launcher:: {
    open(key, bundleId, fromMods=null, conditions=null)::
      core.basic(
        core.from(key, fromMods),
        core.toApp(bundleId),
        { conditions: conditions }
      ),

    openPath(key, appPath, fromMods=null, conditions=null)::
      core.basic(
        core.from(key, fromMods),
        core.toShell("open '" + appPath + "'"),
        { conditions: conditions }
      ),

    apps:: {
      terminal(key, fromMods=null):: $.launcher.open(key, 'com.apple.Terminal', fromMods),
      iterm(key, fromMods=null):: $.launcher.open(key, 'com.googlecode.iterm2', fromMods),
      safari(key, fromMods=null):: $.launcher.open(key, 'com.apple.Safari', fromMods),
      chrome(key, fromMods=null):: $.launcher.open(key, 'com.google.Chrome', fromMods),
      firefox(key, fromMods=null):: $.launcher.open(key, 'org.mozilla.firefox', fromMods),
      vscode(key, fromMods=null):: $.launcher.open(key, 'com.microsoft.VSCode', fromMods),
      finder(key, fromMods=null):: $.launcher.open(key, 'com.apple.finder', fromMods),
      notes(key, fromMods=null):: $.launcher.open(key, 'com.apple.Notes', fromMods),
      slack(key, fromMods=null):: $.launcher.open(key, 'com.tinyspeck.slackmacgap', fromMods),
      spotify(key, fromMods=null):: $.launcher.open(key, 'com.spotify.client', fromMods),
      activityMonitor(key, fromMods=null):: $.launcher.open(key, 'com.apple.ActivityMonitor', fromMods),
      systemPreferences(key, fromMods=null):: $.launcher.open(key, 'com.apple.systempreferences', fromMods),
    },
  },
}
