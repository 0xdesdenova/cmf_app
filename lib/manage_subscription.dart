import 'package:flutter/material.dart';
import 'dart:convert';

// Models
import 'user.dart';

// Packages
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

bool loading = false;
String checkoutId = '';
int subscription = 0;

// API Calls
Future updateSubscription(
    {required BuildContext context,
    required userId,
    required String subscriptionLevel}) async {
  Uri uri =
      Uri.parse('https://choosemyfitness-api.herokuapp.com/api/users/$userId/');

  var response = await http.patch(uri, body: {
    'subscription_level': subscriptionLevel,
  });

  if (response.statusCode == 200) {
    Provider.of<UserData>(context, listen: false).updateUser();
    return true;
  } else {
    return false;
  }
}

void recurrenteSetup({required userId}) async {
  if (!loading) {
    Uri uri = Uri.parse(
        'https://choosemyfitness-api.herokuapp.com/api/users/recurrente_setup/');

    loading = true;

    var response = await http.post(uri, body: {'id': userId.toString()});

    loading = false;

    if (response.statusCode == 202) {
      checkoutId = json.decode(response.body)['checkout_id'];
      Uri recurrenteUri = Uri.parse('https://app.recurrente.com/c/$checkoutId');
      await canLaunchUrl(recurrenteUri)
          ? await launchUrl(recurrenteUri)
          : throw 'Could not launch $uri';
    }
  }
}

Future addCreditCard({required BuildContext context, required userId}) async {
  Uri uri = Uri.parse(
      'https://choosemyfitness-api.herokuapp.com/api/users/fetch_credit_card/');

  var response = await http.post(uri,
      body: {'user_id': userId.toString(), 'checkout_id': checkoutId});

  if (response.statusCode == 202) {
    checkoutId = '';
    Provider.of<UserData>(context, listen: false).updateUser();
    return true;
  } else {
    return false;
  }
}

Future removeCreditCard(
    {required BuildContext context, required creditCardId}) async {
  Uri uri = Uri.parse(
      'https://choosemyfitness-api.herokuapp.com/api/users/credit_cards/$creditCardId/');

  var response = await http.delete(uri);

  if (response.statusCode == 204) {
    Provider.of<UserData>(context, listen: false).updateUser();
    return true;
  } else {
    return false;
  }
}

ListTile buildCreditCard({required BuildContext context, required Map user}) {
  Map creditCard = user['credit_card'] ?? {};
  if (creditCard.isEmpty) {
    return ListTile(
      onLongPress: () {
        recurrenteSetup(userId: user['id']);
      },
      leading: const Icon(Icons.credit_card),
      title: const Text('Hold to Add Card'),
      subtitle: const Text('Visa, Mastercard, AMEX'),
      trailing:
          loading ? const CircularProgressIndicator() : const Icon(Icons.add),
    );
  } else {
    return ListTile(
      leading: const Icon(Icons.credit_card),
      title: Text('Card ending in ${creditCard['last_digits']}'),
      subtitle: Text(
          'Expires ${creditCard['expiration_month']}/${creditCard['expiration_year']}'),
      trailing: IconButton(
          onPressed: () async {
            await removeCreditCard(
              context: context,
              creditCardId: user['credit_card']['id'],
            ).then((value) => value ? Navigator.pop(context, true) : null);
          },
          icon: const Icon(Icons.clear)),
    );
  }
}

void manageSubscription({required BuildContext context, required Map user}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Credit Card',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                buildCreditCard(context: context, user: user),
                user['credit_card'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Subscription Level',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'Hold down to subscribe',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          ListTile(
                            onLongPress: () async {
                              bool success = await updateSubscription(
                                context: context,
                                userId: user['id'],
                                subscriptionLevel: '1',
                              );
                              if (success) {
                                Navigator.pop(context, true);
                              }
                            },
                            title: const Text('Ultimate'),
                            subtitle: const Text('Voltio, Orange Theory'),
                            trailing: subscription == 1
                                ? const Icon(Icons.radio_button_on)
                                : const Icon(Icons.radio_button_off),
                          ),
                          ListTile(
                            onLongPress: () async {
                              bool success = await updateSubscription(
                                context: context,
                                userId: user['id'],
                                subscriptionLevel: '2',
                              );
                              if (success) {
                                Navigator.pop(context, true);
                              }
                            },
                            title: const Text('Premium'),
                            subtitle: const Text('Fitness One, World Gym'),
                            trailing: subscription == 2
                                ? const Icon(Icons.radio_button_on)
                                : const Icon(Icons.radio_button_off),
                          ),
                          ListTile(
                            onLongPress: () async {
                              bool success = await updateSubscription(
                                context: context,
                                userId: user['id'],
                                subscriptionLevel: '3',
                              );
                              if (success) {
                                Navigator.pop(context, true);
                              }
                            },
                            title: const Text('Basic'),
                            subtitle: const Text('Sporta, Exerzone'),
                            trailing: subscription == 3
                                ? const Icon(Icons.radio_button_on)
                                : const Icon(Icons.radio_button_off),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        },
      );
    },
  ).then((value) => value ?? false
      ? ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Subscription Updated')))
      : null);
}
