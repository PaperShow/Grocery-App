import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  getTopPickedStore() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStore() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('shopOpen',
            isEqualTo:
                true) // add or remove where option for more filteration in shop data
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStorePaginQuery() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName');
  }
}
