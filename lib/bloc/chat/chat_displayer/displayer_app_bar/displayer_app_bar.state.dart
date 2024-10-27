abstract class DisplayerAppBarState{}

class OnlineInitial extends DisplayerAppBarState{}

class OnlineUpadted extends DisplayerAppBarState{
  final bool isOnline;

  OnlineUpadted({required this.isOnline}  );
}