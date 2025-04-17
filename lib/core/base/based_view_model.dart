import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';



abstract class Disposable {
  void dispose();
}

abstract class BasedViewModel<State> implements Disposable {
  BasedViewModel(State initialState) : _stateSignal = StateSignal(initialState);

  final StateSignal<State> _stateSignal;

  ReadonlySignal<State> get state => _stateSignal.readonly;

  @protected
  void updateState(State newState) => _stateSignal.updateState(newState);

  @override
  void dispose() => _stateSignal.dispose();
}

class StateSignal<State> implements Disposable {
  StateSignal(State initialState) : _signal = signal(initialState);

  final Signal<State> _signal;

  void updateState(State newState) => _signal.value = newState;
  
 
  ReadonlySignal<State> get readonly => _signal.readonly();

  @override
  void dispose() => _signal.dispose();
}