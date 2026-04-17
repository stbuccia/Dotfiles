import QtQuick
import Quickshell
import Quickshell.Io

import qs.Commons
import qs.Services.UI

Item {
  id: root

  property var pluginApi: null

  property bool checkingEngine: true
  property bool engineAvailable: false
  property bool isApplying: false
  property bool stopRequested: false
  property bool recoveryInProgress: false
  property string lastError: ""
  property string lastErrorDetails: ""
  property string statusMessage: ""
  readonly property bool engineRunning: engineProcess.running || isApplying || pendingCommand.length > 0

  property var pendingCommand: []

  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  Component.onCompleted: {
    Logger.i("LWEController", "Main initialized");
  }

  function ensureSettingsRoot() {
    if (!pluginApi) {
      return;
    }

    if (pluginApi.pluginSettings.screens === undefined || pluginApi.pluginSettings.screens === null) {
      pluginApi.pluginSettings.screens = {};
    }

    if (pluginApi.pluginSettings.lastKnownGoodScreens === undefined || pluginApi.pluginSettings.lastKnownGoodScreens === null) {
      pluginApi.pluginSettings.lastKnownGoodScreens = {};
    }

    if (pluginApi.pluginSettings.wallpaperProperties === undefined || pluginApi.pluginSettings.wallpaperProperties === null) {
      pluginApi.pluginSettings.wallpaperProperties = {};
    }

    if (pluginApi.pluginSettings.runtimeRecoveryPending === undefined || pluginApi.pluginSettings.runtimeRecoveryPending === null) {
      pluginApi.pluginSettings.runtimeRecoveryPending = false;
    }
  }

  function cloneValue(value) {
    return JSON.parse(JSON.stringify(value || ({})));
  }

  function hasAnyScreenPathFrom(sourceScreens) {
    const screens = sourceScreens || ({});
    const keys = Object.keys(screens);
    for (const key of keys) {
      const screenCfg = screens[key] || ({});
      const path = normalizedPath(screenCfg.path || "");
      if (path.length > 0) {
        return true;
      }
    }
    return false;
  }

  function markRuntimeRecoveryPending(value, flushToDisk = true) {
    if (!pluginApi) {
      return;
    }

    ensureSettingsRoot();
    const nextValue = !!value;
    if (pluginApi.pluginSettings.runtimeRecoveryPending === nextValue) {
      return;
    }

    pluginApi.pluginSettings.runtimeRecoveryPending = nextValue;
    if (flushToDisk) {
      pluginApi.saveSettings();
    }
  }

  function saveCurrentLayoutAsLastKnownGood(reason) {
    if (!pluginApi) {
      return false;
    }

    ensureSettingsRoot();

    const currentScreens = cloneValue(pluginApi.pluginSettings.screens || ({}));
    if (!hasAnyScreenPathFrom(currentScreens)) {
      Logger.d("LWEController", "Skip last-known-good snapshot: no configured paths", "reason=", reason);
      return false;
    }

    pluginApi.pluginSettings.lastKnownGoodScreens = currentScreens;
    pluginApi.pluginSettings.runtimeRecoveryPending = false;
    pluginApi.saveSettings();

    Logger.i("LWEController", "Saved last-known-good layout", "reason=", reason);
    return true;
  }

  function restoreLastKnownGoodLayout(reason) {
    if (!pluginApi) {
      return false;
    }

    ensureSettingsRoot();

    const snapshot = pluginApi.pluginSettings.lastKnownGoodScreens || ({});
    if (!hasAnyScreenPathFrom(snapshot)) {
      Logger.w("LWEController", "No restorable last-known-good layout", "reason=", reason);
      return false;
    }

    pluginApi.pluginSettings.screens = cloneValue(snapshot);
    pluginApi.pluginSettings.runtimeRecoveryPending = false;
    pluginApi.saveSettings();

    Logger.i("LWEController", "Restored last-known-good layout", "reason=", reason);
    return true;
  }

  function tryAutoRecoverFromRuntimeError(reason) {
    if (!pluginApi || recoveryInProgress) {
      return false;
    }

    if (!restoreLastKnownGoodLayout(reason)) {
      markRuntimeRecoveryPending(true);
      return false;
    }

    markErrorAsRecovered();
    recoveryInProgress = true;
    if (engineAvailable && hasAnyConfiguredWallpaper()) {
      restartEngine();
    }

    return true;
  }

  function recoverPendingLayoutOnStartup() {
    if (!pluginApi) {
      return false;
    }

    ensureSettingsRoot();
    const pending = !!pluginApi.pluginSettings.runtimeRecoveryPending;
    if (!pending) {
      return false;
    }

    const restored = restoreLastKnownGoodLayout("startup-pending-recovery");
    if (!restored) {
      markRuntimeRecoveryPending(false);
      return false;
    }

    Logger.i("LWEController", "Startup recovery applied from pending marker");
    return true;
  }

  readonly property string defaultScaling: cfg.defaultScaling ?? defaults.defaultScaling ?? "fill"
  readonly property string defaultClamp: cfg.defaultClamp ?? defaults.defaultClamp ?? "clamp"
  readonly property int defaultFps: cfg.defaultFps ?? defaults.defaultFps ?? 30

  readonly property int defaultVolume: {
    const value = Number(cfg.defaultVolume ?? defaults.defaultVolume ?? 100);
    if (isNaN(value)) {
      return 100;
    }
    return Math.max(0, Math.min(100, Math.floor(value)));
  }

  readonly property bool defaultMuted: cfg.defaultMuted ?? defaults.defaultMuted ?? true
  readonly property bool defaultAudioReactiveEffects: cfg.defaultAudioReactiveEffects ?? defaults.defaultAudioReactiveEffects ?? true
  readonly property bool defaultNoAutomute: cfg.defaultNoAutomute ?? defaults.defaultNoAutomute ?? false
  readonly property bool defaultDisableMouse: cfg.defaultDisableMouse ?? defaults.defaultDisableMouse ?? false
  readonly property bool defaultDisableParallax: cfg.defaultDisableParallax ?? defaults.defaultDisableParallax ?? false
  readonly property bool defaultNoFullscreenPause: cfg.defaultNoFullscreenPause ?? defaults.defaultNoFullscreenPause ?? false
  readonly property bool defaultFullscreenPauseOnlyActive: cfg.defaultFullscreenPauseOnlyActive ?? defaults.defaultFullscreenPauseOnlyActive ?? false
  readonly property bool defaultAutoApply: cfg.autoApplyOnStartup ?? defaults.autoApplyOnStartup ?? true
  readonly property string assetsDir: cfg.assetsDir ?? defaults.assetsDir ?? ""

  function normalizedPath(path) {
    return Settings.preprocessPath(String(path || ""));
  }

  function getScreenConfig(screenName) {
    const screenConfigs = cfg.screens || ({});
    const raw = screenConfigs[screenName] || ({});

    return {
      path: raw.path ?? "",
      scaling: raw.scaling ?? defaultScaling,
      clamp: raw.clamp ?? defaultClamp
    };
  }

  function hasAnyConfiguredWallpaper() {
    for (const screen of Quickshell.screens) {
      const screenCfg = getScreenConfig(screen.name);
      if (screenCfg.path && screenCfg.path.length > 0) {
        return true;
      }
    }
    return false;
  }

  function wallpaperIdFromPath(path) {
    const raw = normalizedPath(path);
    if (raw.length === 0) {
      return "";
    }

    const parts = raw.split("/");
    return parts.length > 0 ? String(parts[parts.length - 1] || "") : "";
  }

  function cloneWallpaperProperties(source) {
    const cloned = {};
    const raw = source || ({});
    for (const key of Object.keys(raw)) {
      const value = raw[key];
      if (value !== undefined) {
        cloned[key] = value;
      }
    }
    return cloned;
  }

  function setWallpaperProperties(path, properties) {
    if (!pluginApi) {
      return;
    }

    ensureSettingsRoot();
    const wallpaperId = wallpaperIdFromPath(path);
    if (wallpaperId.length === 0) {
      return;
    }

    pluginApi.pluginSettings.wallpaperProperties[wallpaperId] = cloneWallpaperProperties(properties);
  }

  function getWallpaperProperties(path) {
    const wallpaperId = wallpaperIdFromPath(path);
    if (wallpaperId.length === 0) {
      return {};
    }

    const raw = cfg.wallpaperProperties || ({});
    return cloneWallpaperProperties(raw[wallpaperId] || ({}));
  }

  function setScreenWallpaper(screenName, path) {
    setScreenWallpaperWithOptions(screenName, path, ({}));
  }

  function clearLegacyScreenRuntimeOptions(screenName) {
    const screenConfig = pluginApi?.pluginSettings?.screens?.[screenName];
    if (!screenConfig) {
      return;
    }

    delete screenConfig.clamp;
    delete screenConfig.volume;
    delete screenConfig.muted;
    delete screenConfig.audioReactiveEffects;
    delete screenConfig.noAutomute;
    delete screenConfig.disableMouse;
    delete screenConfig.disableParallax;
  }

  function clearLegacyRuntimeOptionsForAllScreens() {
    for (const screen of Quickshell.screens) {
      clearLegacyScreenRuntimeOptions(screen.name);
    }
  }

  function setScreenWallpaperWithOptions(screenName, path, options) {
    if (!pluginApi) {
      return;
    }

    Logger.i("LWEController", "Set wallpaper requested", screenName, path, JSON.stringify(options || ({})));

    ensureSettingsRoot();

    if (pluginApi.pluginSettings.screens[screenName] === undefined) {
      pluginApi.pluginSettings.screens[screenName] = {};
    }

    pluginApi.pluginSettings.screens[screenName].path = path;

    const resolvedScaling = (options?.scaling || "").trim();
    const resolvedClamp = (options?.clamp || "").trim();
    if (resolvedScaling.length > 0) {
      pluginApi.pluginSettings.screens[screenName].scaling = resolvedScaling;
    }
    if (resolvedClamp.length > 0) {
      pluginApi.pluginSettings.defaultClamp = resolvedClamp;
    }

    if (options?.volume !== undefined) {
      const rawVolume = Number(options.volume);
      if (!isNaN(rawVolume)) {
        pluginApi.pluginSettings.defaultVolume = Math.max(0, Math.min(100, Math.floor(rawVolume)));
      }
    }

    if (options?.muted !== undefined) {
      pluginApi.pluginSettings.defaultMuted = !!options.muted;
    }

    if (options?.audioReactiveEffects !== undefined) {
      pluginApi.pluginSettings.defaultAudioReactiveEffects = !!options.audioReactiveEffects;
    }

    if (options?.noAutomute !== undefined) {
      pluginApi.pluginSettings.defaultNoAutomute = !!options.noAutomute;
    }

    if (options?.disableMouse !== undefined) {
      pluginApi.pluginSettings.defaultDisableMouse = !!options.disableMouse;
    }

    if (options?.disableParallax !== undefined) {
      pluginApi.pluginSettings.defaultDisableParallax = !!options.disableParallax;
    }

    clearLegacyScreenRuntimeOptions(screenName);

    if (options?.customProperties !== undefined) {
      setWallpaperProperties(path, options.customProperties);
    }

    pluginApi.saveSettings();

    restartEngine();
  }

  function clearScreenWallpaper(screenName) {
    if (!pluginApi) {
      return;
    }

    Logger.i("LWEController", "Clear wallpaper requested", screenName);

    ensureSettingsRoot();

    if (pluginApi.pluginSettings.screens[screenName] === undefined) {
      pluginApi.pluginSettings.screens[screenName] = {};
    }

    pluginApi.pluginSettings.screens[screenName].path = "";
    pluginApi.saveSettings();

    restartEngine();
  }

  function setAllScreensWallpaper(path) {
    setAllScreensWallpaperWithOptions(path, ({}));
  }

  function setAllScreensWallpaperWithOptions(path, options) {
    if (!pluginApi || !path || path.length === 0) {
      return;
    }

    Logger.i("LWEController", "Set wallpaper for all screens", path, JSON.stringify(options || ({})));

    ensureSettingsRoot();

    const resolvedScaling = (options?.scaling || "").trim();
    const resolvedClamp = (options?.clamp || "").trim();
    const resolvedVolumeRaw = Number(options?.volume);
    const hasResolvedVolume = !isNaN(resolvedVolumeRaw);
    const resolvedVolume = hasResolvedVolume ? Math.max(0, Math.min(100, Math.floor(resolvedVolumeRaw))) : 0;
    const hasMuted = options?.muted !== undefined;
    const hasAudioReactive = options?.audioReactiveEffects !== undefined;
    const hasNoAutomute = options?.noAutomute !== undefined;
    const hasDisableMouse = options?.disableMouse !== undefined;
    const hasDisableParallax = options?.disableParallax !== undefined;

    for (const screen of Quickshell.screens) {
      if (pluginApi.pluginSettings.screens[screen.name] === undefined) {
        pluginApi.pluginSettings.screens[screen.name] = {};
      }

      pluginApi.pluginSettings.screens[screen.name].path = path;
      if (resolvedScaling.length > 0) {
        pluginApi.pluginSettings.screens[screen.name].scaling = resolvedScaling;
      }
      if (options?.customProperties !== undefined) {
        setWallpaperProperties(path, options.customProperties);
      }
    }

    if (resolvedClamp.length > 0) {
      pluginApi.pluginSettings.defaultClamp = resolvedClamp;
    }

    if (hasResolvedVolume) {
      pluginApi.pluginSettings.defaultVolume = resolvedVolume;
    }
    if (hasMuted) {
      pluginApi.pluginSettings.defaultMuted = !!options.muted;
    }
    if (hasAudioReactive) {
      pluginApi.pluginSettings.defaultAudioReactiveEffects = !!options.audioReactiveEffects;
    }
    if (hasNoAutomute) {
      pluginApi.pluginSettings.defaultNoAutomute = !!options.noAutomute;
    }
    if (hasDisableMouse) {
      pluginApi.pluginSettings.defaultDisableMouse = !!options.disableMouse;
    }
    if (hasDisableParallax) {
      pluginApi.pluginSettings.defaultDisableParallax = !!options.disableParallax;
    }

    clearLegacyRuntimeOptionsForAllScreens();

    pluginApi.saveSettings();
    restartEngine();
  }

  function extractRuntimeError(stderrText) {
    const text = (stderrText || "").trim();
    if (text.length === 0) {
      return "";
    }

    const lower = text.toLowerCase();

    if (lower.indexOf("cannot find a valid assets folder") !== -1) {
      return pluginApi?.tr("main.error.assetsMissing");
    }

    if (lower.indexOf("at least one background id must be specified") !== -1) {
      return pluginApi?.tr("main.error.noBackground");
    }

    if (lower.indexOf("opengl") !== -1 || lower.indexOf("glfw") !== -1) {
      return pluginApi?.tr("main.error.opengl");
    }

    const lines = text.split(/\r?\n/)
      .map(line => (line || "").trim())
      .filter(line => line.length > 0);

    if (lines.length === 0) {
      return "";
    }

    let summary = lines[0];
    for (const line of lines) {
      const normalized = line.toLowerCase();
      if (normalized.indexOf("error") !== -1 || normalized.indexOf("failed") !== -1) {
        summary = line;
        break;
      }
    }

    const maxLength = 220;
    if (summary.length > maxLength) {
      summary = summary.substring(0, maxLength) + "...";
    }

    return summary;
  }

  function setRuntimeErrorFromStderr(stderrText) {
    const raw = (stderrText || "").trim();
    if (raw.length === 0) {
      return false;
    }

    const summary = extractRuntimeError(raw);
    if (summary.length === 0) {
      return false;
    }

    lastError = summary;
    lastErrorDetails = raw;
    return true;
  }

  function markErrorAsRecovered() {
    const hintRaw = pluginApi?.tr("main.error.autoRecovered");
    if (hintRaw === undefined || hintRaw === null) {
      return;
    }

    const hint = hintRaw.trim();
    const current = (lastError || "").trim();
    if (hint.length === 0 || current.length === 0) {
      return;
    }

    if (current.indexOf(hint) !== -1) {
      return;
    }

    lastError = current + " (" + hint + ")";
  }

  function buildCommand() {
    const command = ["linux-wallpaperengine"];
    let firstPath = "";
    const appendedWallpaperIds = {};
    let runtimeOptions = {
      volume: defaultVolume,
      muted: defaultMuted,
      audioReactiveEffects: defaultAudioReactiveEffects,
      noAutomute: defaultNoAutomute,
      disableMouse: defaultDisableMouse,
      disableParallax: defaultDisableParallax
    };

    for (const candidate of Quickshell.screens) {
      const candidateCfg = getScreenConfig(candidate.name);
      const candidatePath = normalizedPath(candidateCfg.path);
      if (candidatePath && candidatePath.length > 0) {
        break;
      }
    }

    command.push("--fps");
    command.push(String(defaultFps));

    const runtimeClamp = String(defaultClamp || "clamp").trim();
    if (runtimeClamp.length > 0) {
      command.push("--clamp");
      command.push(runtimeClamp);
    }

    if (runtimeOptions.muted) {
      command.push("--silent");
    } else {
      command.push("--volume");
      command.push(String(runtimeOptions.volume));
    }

    if (!runtimeOptions.audioReactiveEffects) {
      command.push("--no-audio-processing");
    }

    if (runtimeOptions.noAutomute) {
      command.push("--noautomute");
    }

    if (runtimeOptions.disableMouse) {
      command.push("--disable-mouse");
    }

    if (runtimeOptions.disableParallax) {
      command.push("--disable-parallax");
    }

    if (defaultNoFullscreenPause) {
      command.push("--no-fullscreen-pause");
    }

    if (defaultFullscreenPauseOnlyActive) {
      command.push("--fullscreen-pause-only-active");
    }

    const maybeAssetsDir = normalizedPath(assetsDir);
    if (maybeAssetsDir.length > 0) {
      command.push("--assets-dir");
      command.push(maybeAssetsDir);
    }

    for (const screen of Quickshell.screens) {
      const screenCfg = getScreenConfig(screen.name);
      const path = normalizedPath(screenCfg.path);
      if (!path || path.length === 0) {
        continue;
      }

      if (firstPath.length === 0) {
        firstPath = path;
      }

      command.push("--screen-root");
      command.push(screen.name);
      command.push("--bg");
      command.push(path);

      command.push("--scaling");
      command.push(String(screenCfg.scaling));

      const wallpaperId = wallpaperIdFromPath(path);
      if (wallpaperId.length > 0 && !appendedWallpaperIds[wallpaperId]) {
        const customProperties = getWallpaperProperties(path);
        for (const propertyKey of Object.keys(customProperties)) {
          const propertyValue = customProperties[propertyKey];
          if (propertyValue === undefined || propertyValue === null || String(propertyKey || "").trim().length === 0) {
            continue;
          }
          command.push("--set-property");
          command.push(String(propertyKey) + "=" + String(propertyValue));
        }
        appendedWallpaperIds[wallpaperId] = true;
      }
    }

    if (firstPath.length > 0) {
      command.push(firstPath);
    }

    return command;
  }

  function stopAll(showToast = false) {
    Logger.i("LWEController", "Stopping engine process");
    pendingCommand = [];

    if (engineProcess.running) {
      stopRequested = true;
      engineProcess.running = false;
    } else {
      stopRequested = false;
    }

    // Always run terminate command to stop detached processes too.
    if (!forceStopProcess.running) {
      forceStopProcess.running = true;
    }

    isApplying = false;
    statusMessage = pluginApi?.tr("main.status.stopped");
    if (showToast) {
      ToastService.showNotice(pluginApi?.tr("panel.title"), pluginApi?.tr("toast.stopped"), "player-stop");
    }
  }

  function startEngineWithCommand(command) {
    if (!engineAvailable) {
      Logger.w("LWEController", "Skip start: engine unavailable");
      return;
    }

    if (!command || command.length <= 1) {
      Logger.w("LWEController", "Skip start: empty command");
      stopAll();
      return;
    }

    Logger.d("LWEController", "Starting engine command", JSON.stringify(command));

    if (!recoveryInProgress) {
      lastError = "";
      lastErrorDetails = "";
    }
    statusMessage = pluginApi?.tr("main.status.starting");
    isApplying = true;

    engineProcess.command = command;
    engineProcess.running = true;
    stableRunTimer.restart();
  }

  function restartEngine() {
    if (!engineAvailable) {
      Logger.w("LWEController", "Skip restart: engine unavailable");
      return;
    }

    if (!hasAnyConfiguredWallpaper()) {
      Logger.i("LWEController", "Skip restart: no configured wallpaper; stopping engine");
      stopAll();
      return;
    }

    const command = buildCommand();
    if (!command || command.length <= 1) {
      Logger.w("LWEController", "Restart resolved to empty command; stopping engine");
      stopAll();
      return;
    }

    if (engineProcess.running) {
      Logger.d("LWEController", "Engine already running; queue restart command");
      pendingCommand = command;
      stopRequested = true;
      engineProcess.running = false;

      // Ensure termination also reaches detached processes before restart.
      if (!forceStopProcess.running) {
        forceStopProcess.running = true;
      }
      return;
    }

    startEngineWithCommand(command);
  }

  function reload(showToast = false) {
    if (!hasAnyConfiguredWallpaper()) {
      lastError = "";
      lastErrorDetails = "";
      statusMessage = pluginApi?.tr("main.status.ready");
      Logger.i("LWEController", "Reload skipped: no configured wallpaper paths");
      if (showToast) {
        ToastService.showWarning(pluginApi?.tr("panel.title"), pluginApi?.tr("toast.reloadSkippedNoWallpaper"), "alert-circle");
      }
      return;
    }

    restartEngine();
    if (showToast) {
      ToastService.showNotice(pluginApi?.tr("panel.title"), pluginApi?.tr("toast.reloaded"), "refresh");
    }
  }

  Process {
    id: engineCheck
    running: true
    command: ["sh", "-c", "command -v linux-wallpaperengine >/dev/null 2>&1"]

    onExited: function (exitCode) {
      root.engineAvailable = (exitCode === 0);
      root.checkingEngine = false;

      Logger.i("LWEController", "Engine check finished", "exitCode=", exitCode, "available=", root.engineAvailable);

      if (!root.engineAvailable) {
        root.lastError = root.pluginApi?.tr("main.error.notInstalled");
        root.lastErrorDetails = "";
        root.statusMessage = root.pluginApi?.tr("main.status.unavailable");
        Logger.e("LWEController", "linux-wallpaperengine binary not found in PATH");
        return;
      }

      root.statusMessage = root.pluginApi?.tr("main.status.ready");

      root.recoverPendingLayoutOnStartup();

      if (root.defaultAutoApply && root.hasAnyConfiguredWallpaper()) {
        Logger.i("LWEController", "Auto apply enabled with configured wallpapers; restarting engine");
        root.restartEngine();
      }
    }

    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  Process {
    id: engineProcess

    onExited: function (exitCode, exitStatus) {
      root.isApplying = false;
      stableRunTimer.stop();

      Logger.i("LWEController", "Engine process exited", "exitCode=", exitCode, "exitStatus=", exitStatus, "stopRequested=", root.stopRequested);

      if (root.stopRequested) {
        root.stopRequested = false;
        root.recoveryInProgress = false;

        if (root.pendingCommand.length > 0) {
          const nextCommand = root.pendingCommand;
          root.pendingCommand = [];
          Logger.d("LWEController", "Applying pending command after stop");
          root.startEngineWithCommand(nextCommand);
          return;
        }

        root.statusMessage = root.pluginApi?.tr("main.status.stopped");
        return;
      }

      if (exitCode !== 0 || exitStatus !== Process.NormalExit) {
        if (root.setRuntimeErrorFromStderr(stderr.text)) {
          Logger.e("LWEController", "Engine runtime error", root.lastError);
        }
        root.tryAutoRecoverFromRuntimeError("runtime-crash");
        root.statusMessage = root.pluginApi?.tr("main.status.crashed");
      } else {
        root.recoveryInProgress = false;
        root.statusMessage = root.pluginApi?.tr("main.status.stopped");
      }
    }

    stdout: StdioCollector {}

    stderr: StdioCollector {
      onStreamFinished: {
        if (root.stopRequested) {
          return;
        }

        if (root.setRuntimeErrorFromStderr(text)) {
          Logger.w("LWEController", "Engine stderr", root.lastError);
        }
      }
    }
  }

  Process {
    id: forceStopProcess
    running: false
    command: [
      "sh",
      "-c",
      "if command -v pkill >/dev/null 2>&1; then pkill -x linux-wallpaper >/dev/null 2>&1 || true; pkill -f '(^|/)linux-wallpaperengine([[:space:]]|$)' >/dev/null 2>&1 || true; fi"
    ]

    onExited: function (exitCode) {
      Logger.d("LWEController", "Force stop command finished", "exitCode=", exitCode);
    }

    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  IpcHandler {
    target: "plugin:linux-wallpaperengine-controller"

    function toggle() {
      if (root.pluginApi) {
        root.pluginApi.withCurrentScreen(screen => {
          root.pluginApi.togglePanel(screen);
        });
      }
    }

    function apply(screenName, bgPath) {
      if (!screenName || !bgPath) {
        Logger.w("LWEController", "IPC apply ignored due to invalid args", screenName, bgPath);
        return;
      }

      Logger.i("LWEController", "IPC apply", screenName, bgPath);

      root.setScreenWallpaper(screenName, bgPath);
    }

    function stop(screenName) {
      if (!screenName || screenName === "all") {
        Logger.i("LWEController", "IPC stop all");
        root.stopAll();
        return;
      }

      Logger.i("LWEController", "IPC stop screen", screenName);

      root.clearScreenWallpaper(screenName);
    }

    function reload() {
      root.reload();
    }
  }

  Timer {
    id: stableRunTimer
    interval: 2500
    repeat: false

    onTriggered: {
      if (!engineProcess.running || stopRequested) {
        return;
      }

      if (saveCurrentLayoutAsLastKnownGood("stable-run")) {
        recoveryInProgress = false;
      }
    }
  }
}
