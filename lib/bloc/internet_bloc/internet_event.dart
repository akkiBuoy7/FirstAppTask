part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InternetConnectedEvent extends InternetEvent{

}

class InternetLostEvent extends InternetEvent{

}