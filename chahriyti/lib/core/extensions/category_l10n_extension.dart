import 'package:flutter/material.dart';
import '../constants/categories.dart';
import 'l10n_extension.dart';

extension ExpenseCategoryL10n on ExpenseCategory {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ExpenseCategory.essentials:
        return l10n.catEssentials;
      case ExpenseCategory.homeFamily:
        return l10n.catHomeFamily;
      case ExpenseCategory.luxuries:
        return l10n.catLuxuries;
      case ExpenseCategory.health:
        return l10n.catHealth;
      case ExpenseCategory.transport:
        return l10n.catTransport;
      case ExpenseCategory.clothing:
        return l10n.catClothing;
      case ExpenseCategory.restaurants:
        return l10n.catRestaurants;
      case ExpenseCategory.education:
        return l10n.catEducation;
      case ExpenseCategory.other:
        return l10n.catOther;
    }
  }
}

extension ExpenseSubcategoryL10n on ExpenseSubcategory {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ExpenseSubcategory.food:
        return l10n.subFood;
      case ExpenseSubcategory.essentialsTransport:
        return l10n.subTransport;
      case ExpenseSubcategory.bills:
        return l10n.subBills;
      case ExpenseSubcategory.essentialsMedicine:
        return l10n.subMedicine;
      case ExpenseSubcategory.household:
        return l10n.subHousehold;
      case ExpenseSubcategory.children:
        return l10n.subChildren;
      case ExpenseSubcategory.gifts:
        return l10n.subGifts;
      case ExpenseSubcategory.homeFamilyOther:
        return l10n.subOther;
      case ExpenseSubcategory.luxuriesRestaurants:
        return l10n.subRestaurants;
      case ExpenseSubcategory.coffee:
        return l10n.subCoffee;
      case ExpenseSubcategory.luxuriesClothing:
        return l10n.subClothing;
      case ExpenseSubcategory.entertainment:
        return l10n.subEntertainment;
      case ExpenseSubcategory.doctor:
        return l10n.subDoctor;
      case ExpenseSubcategory.pharmacy:
        return l10n.subPharmacy;
      case ExpenseSubcategory.hospital:
        return l10n.subHospital;
      case ExpenseSubcategory.labTests:
        return l10n.subLabTests;
      case ExpenseSubcategory.healthOther:
        return l10n.subOther;
      case ExpenseSubcategory.fuel:
        return l10n.subFuel;
      case ExpenseSubcategory.carMaintenance:
        return l10n.subCarMaintenance;
      case ExpenseSubcategory.taxi:
        return l10n.subTaxi;
      case ExpenseSubcategory.transportTicket:
        return l10n.subTransportTicket;
      case ExpenseSubcategory.transportOther:
        return l10n.subOther;
      case ExpenseSubcategory.menClothing:
        return l10n.subMenClothing;
      case ExpenseSubcategory.womenClothing:
        return l10n.subWomenClothing;
      case ExpenseSubcategory.kidsClothing:
        return l10n.subKidsClothing;
      case ExpenseSubcategory.shoes:
        return l10n.subShoes;
      case ExpenseSubcategory.clothingOther:
        return l10n.subOther;
      case ExpenseSubcategory.restaurant:
        return l10n.subRestaurant;
      case ExpenseSubcategory.fastFood:
        return l10n.subFastFood;
      case ExpenseSubcategory.cafe:
        return l10n.subCafe;
      case ExpenseSubcategory.delivery:
        return l10n.subDelivery;
      case ExpenseSubcategory.restaurantsOther:
        return l10n.subOther;
      case ExpenseSubcategory.schoolUniversity:
        return l10n.subSchoolUniversity;
      case ExpenseSubcategory.tutoring:
        return l10n.subTutoring;
      case ExpenseSubcategory.booksStationery:
        return l10n.subBooksStationery;
      case ExpenseSubcategory.trainingCourses:
        return l10n.subTrainingCourses;
      case ExpenseSubcategory.educationOther:
        return l10n.subOther;
      case ExpenseSubcategory.otherExpense:
        return l10n.subOther;
    }
  }
}
