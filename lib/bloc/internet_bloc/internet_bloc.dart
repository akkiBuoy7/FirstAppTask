import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {

  Connectivity _connectivity;
  late bool _isConnected;

  StreamSubscription? _connectivityStreamSubscription;

  InternetBloc(this._connectivity) : super(InternetInitialState()) {

    on<InternetConnectedEvent>((event, emit){
      print("######## INTERNET CONNECTED STATE FIRED TV gUIDE");
      emit(InternetConnectedState());
    });
    on<InternetLostEvent>((event, emit) {
      emit(InternetLostState());
    });

  }

  getConnectivity() =>
      _connectivityStreamSubscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
              _isConnected = await InternetConnectionChecker().hasConnection;
          if (_isConnected) {
            add(InternetConnectedEvent());
             print("######## INTERNET CONNECTED EVENT FIRED");
          }else{
            add(InternetLostEvent());
            // print("######## INTERNET LOST EVENT FIRED");

          }
        },
      );

  @override
  Future<void> close() {
    _connectivityStreamSubscription?.cancel();
    return super.close();
  }
}