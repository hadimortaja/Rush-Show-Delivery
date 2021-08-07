import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC {
  List<model.Address> addresses = <model.Address>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  DeliveryAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAddresses();
  }

  void listenForAddresses({String message}) async {
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);
      Scaffold.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        Scaffold.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(
        message: S.of(state.context).addresses_refreshed_successfuly);
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        this.addresses.add(value);
      });
      Scaffold.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
//    if (address.isDefault) {
//      this.addresses.map((model.Address _address) {
//        setState(() {
//          _address.isDefault = false;
//        });
//      });
//    }
    userRepo.updateAddress(address).then((value) {
      //setState(() {});
//      Scaffold.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
//        content: Text(S.of(state.context).the_address_updated_successfully),
//      ));
      setState(() {});
      addresses.clear();
      listenForAddresses(
          message: S.of(state.context).the_address_updated_successfully);
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      Scaffold.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).deliveryAddressRemovedSuccessfully),
      ));
    });
  }
}
