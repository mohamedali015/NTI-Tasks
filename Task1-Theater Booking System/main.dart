import 'dart:io';

List<List<String>> seats = List.generate(5, (i)=> List.generate(5, (j) => 'E')) ;
Map<Map<int, int>, Map<String, String>> usersData = {};

validInput (String type) {
  while (true) {
    String? input = stdin.readLineSync();

    if (input == null || input.trim().isEmpty) {
      print("❌ Invalid input!, try again:\n");
      showOptions() ;
    }
    else {
      if (type == 'int') {
        return int.parse(input) ;
      }
      else {
        return input ;
      }
    }
  }
}

void showOptions () {
  print("Press 1 to book a new seat") ;
  print("Press 2 to show the theater seats") ;
  print("Press 3 to show user data") ;
  print("Press 4 to exit") ;

  int input = validInput('int') ;

  actionOptions(input) ;
}

void actionOptions (input) {
  if (input > 0 || input <= 4) {
    if (input == 1) {
      bookSeat() ;
    }
    else if (input == 2) {
      showTheaterSeats();
    }
    else if (input == 3) {
      showUserData() ;
    }
    else {
      print("") ;
      print("👋 See you back!") ;
      return ;
    }
  }
  else {
    print("❌ invalid select position, try again\n") ;
    showOptions() ;
  }
}

bool validSeat (int row, int column) {
  return ((row <= 5 && row > 0) && (column <= 5 && column > 0)) && seats[row - 1][column - 1] == 'E' ;
}

void bookSeat () {
  print("") ;

  stdout.write("Enter Row (1-5): ") ; 
  int row = validInput('int') ;

  stdout.write("Enter Column (1-5): ") ;
  int column = validInput('int') ;

  if (validSeat(row, column)) {
    stdout.write("Enter Your Name: ") ;
    String name = validInput('str') ;

    stdout.write("Enter Your Phone Number: ") ;
    String number = validInput('str') ;

    seats[row - 1][column - 1] = 'B' ;
    
    usersData[{row: column}] = {
      "name" : name, 
      "phoneNumber" : number
    } ; 
    
    print("✅ Seat booked successfully! \n") ;
    showOptions() ;
  }
  else if ((row < 1 || row > 5) || (column < 1 || column > 5)) {
    print("❌ invalid seat position, try again\n") ;
    showOptions() ;
  }
  else {
    print("❌ Seat is already booked, try another one\n") ;
    showOptions() ;
  }
}

void showTheaterSeats () {
  print("") ;
  print("🎭 Theater Seats : ") ;

  for(int i = 0 ; i < 5; i ++) {
    for (int j = 0 ; j < 5 ; j ++) {
      stdout.write('${seats[i][j]} ') ;
    }
    print('') ;
  }

  print("") ;
  showOptions() ;
}

void showUserData () {
  print("") ;
  print("📃 User Booking Details:") ;

  for (var data in usersData.entries) {
    var seatNumber = data.key ;
    var seatData = data.value ;

    stdout.write("🩹 Seat ${seatNumber}: ");
    print("Name: ${seatData["name"]}, Phone Number: ${seatData['phoneNumber']}.");
  }

  print("") ;
  showOptions() ;
}

void main () {
  print("🎭 Welcome to our Theater 🎭") ;
  print("") ;

  showOptions() ;
}