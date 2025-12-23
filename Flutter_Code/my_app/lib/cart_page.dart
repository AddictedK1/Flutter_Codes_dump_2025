import 'package:flutter/material.dart';

class CartItem {
  final String productImage;
  final String productName;
  final double price;
  final String uom; // Unit of Measurement
  int quantity;

  CartItem({
    required this.productImage,
    required this.productName,
    required this.price,
    required this.uom,
    required this.quantity,
  });

  double get amount => price * quantity;
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // List of cart items with sample data
  List<CartItem> cartItems = [
    CartItem(
      productImage: 'assets/images/apple.png',
      productName: 'Red Apples',
      price: 120.0,
      uom: 'Kg',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/banana.png',
      productName: 'Fresh Bananas',
      price: 80.0,
      uom: 'Dozen',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/rice.png',
      productName: 'Basmati Rice',
      price: 150.0,
      uom: 'Kg',
      quantity: 5,
    ),
    CartItem(
      productImage: 'assets/images/milk.png',
      productName: 'Fresh Milk',
      price: 55.0,
      uom: 'Liter',
      quantity: 3,
    ),
    CartItem(
      productImage: 'assets/images/bread.png',
      productName: 'Whole Wheat Bread',
      price: 45.0,
      uom: 'Loaf',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/tomato.png',
      productName: 'Fresh Tomatoes',
      price: 35.0,
      uom: 'Kg',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/potato.png',
      productName: 'Potatoes',
      price: 25.0,
      uom: 'Kg',
      quantity: 3,
    ),
    CartItem(
      productImage: 'assets/images/onion.png',
      productName: 'Red Onions',
      price: 30.0,
      uom: 'Kg',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/chicken.png',
      productName: 'Chicken Breast',
      price: 250.0,
      uom: 'Kg',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/egg.png',
      productName: 'Farm Fresh Eggs',
      price: 120.0,
      uom: 'Dozen',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/cheese.png',
      productName: 'Cheddar Cheese',
      price: 180.0,
      uom: 'Pack',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/yogurt.png',
      productName: 'Greek Yogurt',
      price: 85.0,
      uom: 'Cup',
      quantity: 4,
    ),
    CartItem(
      productImage: 'assets/images/orange.png',
      productName: 'Sweet Oranges',
      price: 90.0,
      uom: 'Kg',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/carrot.png',
      productName: 'Fresh Carrots',
      price: 40.0,
      uom: 'Kg',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/spinach.png',
      productName: 'Baby Spinach',
      price: 60.0,
      uom: 'Bunch',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/oil.png',
      productName: 'Cooking Oil',
      price: 140.0,
      uom: 'Liter',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/sugar.png',
      productName: 'White Sugar',
      price: 45.0,
      uom: 'Kg',
      quantity: 2,
    ),
    CartItem(
      productImage: 'assets/images/tea.png',
      productName: 'Black Tea',
      price: 95.0,
      uom: 'Pack',
      quantity: 1,
    ),
    CartItem(
      productImage: 'assets/images/pasta.png',
      productName: 'Italian Pasta',
      price: 75.0,
      uom: 'Pack',
      quantity: 3,
    ),
    CartItem(
      productImage: 'assets/images/soap.png',
      productName: 'Hand Soap',
      price: 35.0,
      uom: 'Piece',
      quantity: 2,
    ),
  ];

  double get totalAmount {
    return cartItems.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Cart items list
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Product image placeholder
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Product details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${item.price.toStringAsFixed(2)}/${item.uom}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _decrementQuantity(index),
                                    icon: const Icon(Icons.remove),
                                    constraints: const BoxConstraints(
                                      minHeight: 32,
                                      minWidth: 32,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _incrementQuantity(index),
                                    icon: const Icon(Icons.add),
                                    constraints: const BoxConstraints(
                                      minHeight: 32,
                                      minWidth: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Amount
                        SizedBox(
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${item.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '${item.quantity} ${item.uom}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Total summary
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // Checkout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceeding to checkout...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
