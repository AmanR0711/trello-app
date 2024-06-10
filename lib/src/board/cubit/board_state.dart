import 'package:equatable/equatable.dart';

abstract class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object> get props => [];
}

class BoardLoading extends BoardState {}

class BoardSubmittingSuccess extends BoardState {
  final String success;

  const BoardSubmittingSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class BoardSubmittingFailed extends BoardState {
  final String error;

  const BoardSubmittingFailed(this.error);

  @override
  List<Object> get props => [error];
}