class Pesanan {
  Map<String, OrderItem> items = {};

  void tambahItem(String namaKopi, int jumlah,
      {required String ice, required String sugarLevel}) {
    items[namaKopi] = OrderItem(
      jumlah: jumlah,
      ice: ice,
      sugarLevel: sugarLevel,
    );
  }

  void kurangiItem(String namaKopi, int jumlah) {
    if (items.containsKey(namaKopi)) {
      items[namaKopi]!.jumlah = (items[namaKopi]!.jumlah ?? 0) - jumlah;
      if (items[namaKopi]!.jumlah! <= 0) {
        items.remove(namaKopi);
      }
    }
  }
}

class OrderItem {
  int? jumlah;
  String? ice;
  String? sugarLevel;

  OrderItem({this.jumlah, this.ice, this.sugarLevel});
}
