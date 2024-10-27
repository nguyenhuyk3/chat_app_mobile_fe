abstract class DisplayerAppBarEvent {}

class UpdateOnlineStatus extends DisplayerAppBarEvent {
  final bool isOnline;

  UpdateOnlineStatus({required this.isOnline});
}
