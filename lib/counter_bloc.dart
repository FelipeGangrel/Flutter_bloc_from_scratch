import 'dart:async';
import 'package:flutter_bloc_from_scratch/counter_event.dart';

class CounterBloc {
  int _counter = 0;

  // dados entram pelo sink e saem pelo stream

  final _counterStateController = StreamController<int>();
  StreamSink<int> get _inCounter => _counterStateController.sink;
  // Para o state, expondo apenas uma stream que retorna dados
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // Para eventos, expondo apenas um sink para entrada
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  // método construtor
  CounterBloc() {
    // sempre que houver um novo evento, queremos mapea-lo para um novo state
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent)
      _counter++;
    else 
      _counter--;
    // adicionando o valor do _counter ao sink do nosso _counterStateController
    _inCounter.add(_counter);
  }

  void dispose() {
    // fechar os stream controllers para não termos vazamento de memória
    _counterStateController.close();
    _counterEventController.close();
  }

}