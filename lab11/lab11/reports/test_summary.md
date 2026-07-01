# Lab 11.5 Test Suite Summary

## Number of tests

11 automated tests.

## Types of tests

- Unit tests for `Task` and `TaskRepository`.
- Widget tests for empty state and task creation.
- Navigation test for opening `TaskDetailScreen`.
- Integration-style widget test for add, edit, save, and return-to-list flow.

## Behaviors validated

- New tasks default to incomplete.
- `toggle()` switches completion state both directions.
- Repository add, delete, and update operations work.
- Task list renders the empty state.
- Users can add one or multiple tasks.
- Tapping a task opens the detail screen.
- Saving an edited title updates the task list.

## Known limitations

- The integration test runs with Flutter's widget test framework, not on a real
  device through the `integration_test` package.
- DevTools screenshots must be captured manually from a debug session before
  final submission.
