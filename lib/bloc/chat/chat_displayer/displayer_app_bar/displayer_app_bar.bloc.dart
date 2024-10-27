import 'package:chat_app_mobile_fe/bloc/chat/chat_displayer/displayer_app_bar/displayer_app_bar.event.dart';
import 'package:chat_app_mobile_fe/bloc/chat/chat_displayer/displayer_app_bar/displayer_app_bar.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayerAppBarBloc extends Bloc<DisplayerAppBarEvent, DisplayerAppBarState> {
  DisplayerAppBarBloc() : super(OnlineInitial()) {
    on<UpdateOnlineStatus>(
        (event, emmit) => emmit(OnlineUpadted(isOnline: event.isOnline)));
  }
}
