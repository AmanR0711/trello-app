import 'package:flutter_bloc/flutter_bloc.dart';

import '../../onboarding/service/onboarding_service.dart';
import '../service/dashboard_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardService dashboardService;
  final OnboardingService onboardingService;

  DashboardCubit(
    this.dashboardService,
    this.onboardingService,
  ) : super(DashboardLoading());

  Future<void> getBoards() async {
    try {
      emit(DashboardLoading());
      final user = await onboardingService.getSession();
      final boards = await dashboardService.getBoards();
      emit(DashboardLoaded(user!, boards));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
