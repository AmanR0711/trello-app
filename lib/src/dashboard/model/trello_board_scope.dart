enum TrelloBoardScope {
  noaccess("No-access"),
  readonly("Read-only"),
  readwrite("Read-write");

  final String scope;

  const TrelloBoardScope(this.scope);
}