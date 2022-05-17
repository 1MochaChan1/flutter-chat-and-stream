// ignore_for_file: constant_identifier_names

// for themes
enum CusTheme { Light, Dark, Sunset }

// for pages where user can edit some data.
enum PageState { editing, static }

// for pages where a list of of data is supposed to be loaded
enum DataState { waiting, done, error }

// state for components like List Tile etc.,
enum ChildWidgetState { waiting, done, error }

// state for different types of errors during auth
enum AuthState {
  weakPassword,
  emailAlreadyInUse,
  noUserFound,
  wrongPassword,
  success
}
