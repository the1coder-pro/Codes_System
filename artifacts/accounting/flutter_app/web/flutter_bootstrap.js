{{flutter_js}}
{{flutter_build_config}}

// Load the app directly: a service worker is unnecessary for this UI preview
// and can hold on to older compiled Flutter versions during development.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
  },
});
