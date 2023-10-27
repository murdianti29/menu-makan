import 'package:flutter/material.dart';

void main() {
  runApp(RumahMam());
}

class RumahMam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PilihMenuScreen(),
    );
  }
}

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String imagePath;

  MenuItem({required this.name, required this.description, required this.price, required this.imagePath});
}

class OrderItem {
  final MenuItem menuItem;
  int quantity;

  OrderItem({required this.menuItem, this.quantity = 1});
}

final List<MenuItem> menuItems = [
  MenuItem(
    name: 'Nasi Campur Bali',
    description: 'Nasi Campur yang enak dan gurih',
    price: 25.000,
    imagePath: 'assets/NasiCampurBali.jpg',
  ),
  MenuItem(
    name: 'Ayam Betutu',
    description: 'Ayam Betutu makanan yang pedas dan gurih',
    price: 105.000,
    imagePath: 'assets/ayambetutu.jpg',
  ),
  MenuItem(
    name: 'Sate Lilit',
    description: 'Perpaduan sate ikan yang dililitkan pada batang serai',
    price: 20.000,
    imagePath: 'assets/SateLilit.jpg',
  ),
  MenuItem(
    name: 'Rujak Kuah Pindang',
    description: 'Rujak buah khas Bali yang menggunakan kuah ikan',
    price: 35.000,
    imagePath: 'assets/rujakkuahpindangbali.jpg',
  ),
  MenuItem(
    name: 'Blayag',
    description: 'Perpaduan Blayag dengan urap sayuran yang segar',
    price: 15.000,
    imagePath: 'assets/blayag.jpg',
  ),
];

class PilihMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Menu'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = menuItems[index];
          return Card(
            child: ListTile(
              leading: Image.asset(menuItem.imagePath),
              title: Text(menuItem.name),
              subtitle: Text(menuItem.description),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewMenuScreen(menuItem: menuItem),
                    ),
                  );
                },
                child: Text('Preview'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PreviewMenuScreen extends StatefulWidget {
  final MenuItem menuItem;

  PreviewMenuScreen({required this.menuItem});

  @override
  _PreviewMenuScreenState createState() => _PreviewMenuScreenState();
}

class _PreviewMenuScreenState extends State<PreviewMenuScreen> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalRupiah = widget.menuItem.price * quantity;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(widget.menuItem.imagePath),
          Text(widget.menuItem.name),
          Text(widget.menuItem.description),
          Text('Rp ${totalRupiah.toStringAsFixed(2)}'), // Menampilkan harga dalam mata uang rupiah
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: decreaseQuantity,
              ),
              Text(quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: increaseQuantity,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final orderedItem = OrderItem(menuItem: widget.menuItem, quantity: quantity);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HasilPemesananScreen(orderedItems: [orderedItem]),
                ),
              );
            },
            child: Text('Pesan Menu'),
          ),
        ],
      ),
    );
  }
}

class HasilPemesananScreen extends StatelessWidget {
  final List<OrderItem> orderedItems;

  HasilPemesananScreen({required this.orderedItems});

  @override
  Widget build(BuildContext context) {
    double totalRupiah = 0.0;
    orderedItems.forEach((item) {
      totalRupiah += item.menuItem.price * item.quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pemesanan'),
      ),
      body: ListView.builder(
        itemCount: orderedItems.length,
        itemBuilder: (context, index) {
          final item = orderedItems[index];
          return ListTile(
            title: Text(item.menuItem.name),
            subtitle: Text('Jumlah: ${item.quantity} x Rp ${item.menuItem.price.toStringAsFixed(2)}'), // Menampilkan harga dalam mata uang rupiah
            trailing: Text('Rp ${(item.menuItem.price * item.quantity).toStringAsFixed(2)}'), // Menampilkan harga dalam mata uang rupiah
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total: Rp ${totalRupiah.toStringAsFixed(2)}'), // Menampilkan harga dalam mata uang rupiah
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PilihMenuScreen(),
                    ),
                  );
                },
                child: Text('Kembali ke Pilih Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
