part of 'internet_bloc.dart';

@immutable
abstract class InternetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InternetInitialState extends InternetState{}

class InternetLostState extends InternetState {}

class InternetConnectedState extends InternetState {}
