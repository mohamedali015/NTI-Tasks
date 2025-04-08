import 'dart:io';

void main() {
  Theater theater = Theater(rows: 5, cols: 5);
  print("\n🎭 Welcome To Our Theater 🎭\n");

  while (true) {
    theater.printOptions();
    int choice = getInput<int>(validator: numberValidator(1, 4));

    switch (choice) {
      case 1:
        theater.bookSeat();
        break;
      case 2:
        theater.printSeats();
        break;
      case 3:
        theater.printUsers();
        break;
      case 4:
        print("\n👋 See You Back!\n");
        exit(0);
      default:
        print("\n❌ Invalid choice! Please select a valid option.\n");
    }
  }
}

// 🎭 Theater Class (Manages Seats & Bookings)
class Theater {
  final int rows;
  final int cols;
  late final List<List<Seat>> seats;
  final List<Booking> bookings = [];

  Theater({required this.rows, required this.cols}) {
    seats = List.generate(rows, (row) =>
        List.generate(cols, (col) => Seat(row: row + 1, col: col + 1)));
  }

  void printOptions() {
    print("\n📌 Theater Menu:");
    print("1️⃣ Book a seat");
    print("2️⃣ Show the theater seats");
    print("3️⃣ Show booked users");
    print("4️⃣ Exit");
  }

  void printSeats() {
    print("\n🎭 Theater Seats:");
    for (var row in seats) {
      final buffer = StringBuffer();
      for (var seat in row) {
        buffer.write("${seat.display()} ");
      }
      print(buffer.toString().trim());
    }
  }

  void bookSeat() {
    print("Enter Row (1-$rows):");
    int row = getInput<int>(validator: numberValidator(1, rows)) - 1;

    print("Enter Column (1-$cols):");
    int col = getInput<int>(validator: numberValidator(1, cols)) - 1;

    final seat = seats[row][col];
    if (seat.isBooked) {
      print("\n❌ Seat is already booked! Try another one.");
      return;
    }

    print("Enter Your Name:");
    final name = getInput<String>(validator: nonEmptyValidator("Name"));

    print("Enter Your Phone Number:");
    final phone = getInput<String>(validator: phoneValidator());

    final user = User(name: name, phone: phone);
    final booking = Booking(user: user, seat: seat);
    seat.book();
    bookings.add(booking);

    print("\n✅ Seat booked successfully!");
  }

  void printUsers() {
    if (bookings.isEmpty) {
      print("\n📜 No bookings yet.");
      return;
    }

    print("\n📜 Users Booking Details:");
    for (final booking in bookings) {
      print(booking);
    }
  }
}

// 🛑 Seat Class (Represents a single seat)
class Seat {
  final int row;
  final int col;
  String value;

  Seat({required this.row, required this.col, this.value = 'E'});

  bool get isBooked => value == 'B';

  void book() {
    value = 'B';
  }

  String display() => value;

  @override
  String toString() => "Row $row, Seat $col";
}

// 🧑‍💼 User Class (Stores user details)
class User {
  final String name;
  final String phone;

  User({required this.name, required this.phone});

  @override
  String toString() => "$name - $phone";
}

// 🎟 Booking Class (Encapsulates user & seat together)
class Booking {
  final User user;
  final Seat seat;

  Booking({required this.user, required this.seat});

  @override
  String toString() => "🎟 $seat: $user";
}

// 📌 InputHandler (Handles all input operations)
T getInput<T>({required T? Function(String) validator}) {
  while (true) {
    stdout.write("=> ");
    String? input = stdin.readLineSync()?.trim();

    if (input == null || input.isEmpty) {
      print("\n❌ Input cannot be empty! Try again.\n");
      continue;
    }

    T? validatedValue = validator(input);
    if (validatedValue != null) return validatedValue;

    print("\n❌ Invalid input! Try again.\n");
  }
}

// 🔢 Number range validator
int? Function(String) numberValidator(int min, int max) {
  return (String input) {
    int? value = int.tryParse(input);
    return (value != null && value >= min && value <= max) ? value : null;
  };
}

// 🔠 Non-empty string validator
String? Function(String) nonEmptyValidator(String fieldName) {
  return (String input) =>
  input.trim().isNotEmpty ? input : null;
}

// 📞 Basic phone number validator
String? Function(String) phoneValidator() {
  return (String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    return cleaned.length >= 11 ? input : null;
  };
}
