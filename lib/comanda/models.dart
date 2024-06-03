class Dish {
  int amount;
  String name;

  Dish({required this.amount, required this.name});

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      amount: json['amount'],
      name: json['name'],
    );
  }
}

class Drink {
  int amount;
  String name;

  Drink({required this.amount, required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      amount: json['amount'],
      name: json['name'],
    );
  }
}

class Order {
  List<Dish> dish;
  Drink drink;
  String extraDetails;

  Order({required this.dish, required this.drink, required this.extraDetails});

  factory Order.fromJson(Map<String, dynamic> json) {
    var dishList = json['dishes'] as List;
    List<Dish> dishItems = dishList.map((i) => Dish.fromJson(i)).toList();

    return Order(
      dish: dishItems,
      drink: Drink.fromJson(json['drinks']),
      extraDetails: json['extras'],
    );
  }
}
