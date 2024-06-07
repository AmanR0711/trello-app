import 'package:equatable/equatable.dart';

import '../../onboarding/model/trello_user.dart';
import '../model/trello_board.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final TrelloUser user;
  final List<TrelloBoard> boards;

  const DashboardLoaded(this.user, this.boards);

  @override
  List<Object> get props => [
        user,
        List<TrelloBoard>.from(boards),
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
