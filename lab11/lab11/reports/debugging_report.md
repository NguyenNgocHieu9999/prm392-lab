# Lab 11.4 Debugging Report

## Potential layout issue

The task input row can become tight on very small screens because it combines a
text field and add button horizontally. DevTools Widget Inspector helps verify
the Row, Expanded TextField, and IconButton constraints so overflow problems can
be found quickly.

## Potential performance issue

The full task list rebuilds when the repository notifies listeners. This is fine
for a small lab app, but a large task list could benefit from narrower rebuilds
or more granular state management. DevTools Performance Timeline helps reveal
slow frames and repeated rebuilds during add, edit, toggle, and delete actions.

## How tests and DevTools help

Unit tests protect model and repository behavior. Widget, navigation, and
integration tests verify the user-visible flow from adding a task through editing
it in the detail screen. DevTools complements tests by showing layout constraints,
widget structure, rebuild behavior, and frame timing while the app runs.
