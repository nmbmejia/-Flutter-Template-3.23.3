import 'package:Acorn/models/personal_data_model.dart';

class CustomFunctions {
  //General (List of subscribed services for the day)
  static List<SubscribedService> getSubscriptionsByDay(
      List<SubscribedService> subscriptions, int day) {
    return subscriptions.where((subscription) {
      if (subscription.date == null) return false;

      // Check if the day and month match the subscription date's day and month
      return subscription.date!.day == day;
    }).toList();
  }

  static double getTotalAmountForSubscriptions(
      List<SubscribedService>? servicesSubscribedThisDay) {
    if (servicesSubscribedThisDay == null ||
        servicesSubscribedThisDay.isEmpty) {
      return 0.0; // Return 0 if the list is null or empty
    }

    return servicesSubscribedThisDay.fold(
        0.0, (total, subscription) => total + subscription.price);
  }

  static bool hasMadeAnyPayment(
      List<SubscribedService> services, DateTime currentDate) {
    DateTime normalizedDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    for (SubscribedService service in services) {
      bool hasPayment = service.payments.any((payment) {
        if (payment.date != null) {
          DateTime paymentDate = DateTime(
              payment.date!.year, payment.date!.month, payment.date!.day);
          return paymentDate == normalizedDate;
        }
        return false;
      });

      if (hasPayment) {
        return true;
      }
    }

    return false;
  }

  // Specfici service related for a specific date

  static bool hasMadePayment(SubscribedService subscription, DateTime date) {
    return subscription.payments.any((payment) =>
        payment.date != null &&
        payment.date!.year == date.year &&
        payment.date!.month == date.month &&
        payment.date!.day == date.day);
  }

  static Payment? getPaymentForToday(
      SubscribedService subscription, DateTime date) {
    try {
      return subscription.payments.firstWhere(
        (payment) =>
            payment.date != null &&
            payment.date!.year == date.year &&
            payment.date!.month == date.month &&
            payment.date!.day == date.day,
      );
    } catch (e) {
      return null; // Return null when no match is found.
    }
  }
}
