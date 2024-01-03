//
// Appearance
//
user_pref("widget.allow-client-side-decoration", true);
// Configure tabs
user_pref("browser.allTabs.previews", true);
user_pref("browser.ctrlTab.previews", true);
user_pref("browser.tabs.autoHide", false);
//user_pref("browser.tabs.drawInTitlebar", true);
user_pref("browser.tabs.insertRelatedAfterCurrent", false);
user_pref("browser.tabs.loadFolderAndReplace", false);
user_pref("browser.tabs.loadGroup", 0);
user_pref("browser.tabs.loadInBackground", true);
user_pref("browser.tabs.opentabfor.middleclick", true);
user_pref("browser.tabs.opentabfor.urlbar", true);
user_pref("browser.tabs.tabClipWidth", 25);
user_pref("ui.prefersReducedMotion", 1);
// Do not blink, flash, or jump
user_pref("browser.blink_allowed", false);
user_pref("browser.display.show_image_placeholders", true);
//user_pref("image.animation_mode", "once");
// Sane font sizes
user_pref("font.minimum-size.x-western", 9);
user_pref("font.size.variable.x-western", 13);
//
// Behavior
//
// Find As You Type Configuration
user_pref("accessibility.typeaheadfind.autostart", false);
user_pref("accessibility.typeaheadfind.linksonly", false);
user_pref("accessibility.typeaheadfind.startlinksonly", false);
user_pref("accessibility.typeaheadfind.timeout", 3000);
// Control caching & prefetch
//user_pref("browser.cache.disk.capacity", 0);
//user_pref("browser.cache.disk_cache_ssl", false);
//user_pref("browser.cache.disk.enable", false);
user_pref("browser.sessionhistory.max_entries", 10);
// Popup settings
user_pref("browser.block.target_new_window", true);
// Turn off dumb gesture
user_pref("mousewheel.default.action", 1);
user_pref("mousewheel.horizscroll.withnokey.action", 0);
//
// Security
//
// JS options
user_pref("dom.disable_window_flip", true);
user_pref("dom.disable_window_open_feature.location", true);
user_pref("dom.disable_window_open_feature.menubar", true);
user_pref("dom.disable_window_open_feature.minimizable", true);
user_pref("dom.disable_window_open_feature.resizable", true);
user_pref("dom.disable_window_open_feature.scrollbars", true);
user_pref("dom.disable_window_open_feature.status", true);
// Control cookies and storage
user_pref("browser.history_expire_days_min", 30);
// Do not give out referer links
user_pref("beacon.enabled", false);
user_pref("network.http.sendSecureXSiteReferrer", false);
// Set TLS options
user_pref("security.warn_entering_secure", false);
user_pref("security.warn_submit_insecure", false);
// Set DNS options
user_pref("network.trr.mode", 2);
user_pref("network.trr.bootstrapAddress", "1.1.1.1");
//
// Speed
//
// check about:support
user_pref("browser.tabs.remote.autostart", true);
user_pref("browser.tabs.remote.separateFileUriProcess", true);
user_pref("gfx.canvas.azure.accelerated", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.enabled", true);
user_pref("widget.wayland-dmabuf-vaapi.enabled", true);
//
// Overrides
//
user_pref("browser.download.useDownloadDir", true); // [DEFAULT: false]
user_pref("browser.formfill.enable", true); // [DEFAULT: false]
user_pref("browser.newtabpage.enabled", true); // [DEFAULT: false]
user_pref("browser.shell.shortcutFavicons", true); // [DEFAULT: false]
user_pref("browser.startup.homepage", "about:home");
user_pref("privacy.clearOnShutdown.cookies", false); // Cookies [DEFAULT: true]
user_pref("privacy.clearOnShutdown.downloads", false); // [DEFAULT: true]
user_pref("privacy.firstparty.isolate", true); // [DEFAULT: false]
user_pref("privacy.resistFingerprinting.letterboxing", false); //[DEFAULT: true]
user_pref("privacy.window.maxInnerHeight", 1390);
user_pref("privacy.window.maxInnerWidth", 1280);
user_pref("webgl.disabled", false); // [DEFAULT: true]

/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
user_pref("browser.sessionstore.privacy_level", 0); // 1003 optional to restore cookies/formdata
user_pref("privacy.clearOnShutdown.history", false); // 2811 FF127 or lower
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false); // 2811 FF128+
// 2820 optional to match when you use settings>Cookies and Site Data>Clear Data
user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false); // FF128+
// 2830 optional to match when you use Ctrl-Shift-Del (settings>History>Custom Settings>Clear History)
user_pref("privacy.cpd.history", false); // FF127 or lower
user_pref("privacy.clearHistory.historyFormDataAndDownloads", false); // FF128+