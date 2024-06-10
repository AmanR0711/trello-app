import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dashboard/model/trello_board_bg_color.dart';
import '../service/board_service.dart';
import 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardService boardService;

  BoardCubit(this.boardService) : super(BoardLoading());

  Future<void> createBoard(
    String name,
    String description,
    TrelloBoardBgColor color,
  ) async {
    try {
      emit(BoardLoading());
      await boardService.createBoard(name, description, color);
      emit(const BoardSubmittingSuccess("Board created successfully!"));
    } catch (e) {
      emit(BoardSubmittingFailed(e.toString()));
    }
  }
}
