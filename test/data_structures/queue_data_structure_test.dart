import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/queue_data_structure.dart';

void main() {
  group('QueueDataStructure', () {
    late QueueDataStructure queue;

    setUp(() => queue = QueueDataStructure());

    test('enqueue and dequeue follow FIFO order', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      queue.dequeue();

      expect(queue.nodes.map((node) => node.value), [2, 3]);
    });

    test('front does not mutate the queue', () {
      queue.enqueue(7);
      queue.enqueue(8);
      queue.front();

      expect(queue.nodes.map((node) => node.value), [7, 8]);
      expect(
        queue.animationSteps.last.description,
        contains('Front value is 7'),
      );
    });

    test('empty queue reports its state', () {
      expect(queue.isEmpty(), isTrue);
      queue.enqueue(1);
      expect(queue.isEmpty(), isFalse);
    });
  });
}
