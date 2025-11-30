import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_cupit.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_state.dart';
import 'package:game_vault_seller/features/dashboard/data/account_model.dart';
import 'package:game_vault_seller/features/dashboard/screens/add_account.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/account_state.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/accounts_cupit.dart';
import 'package:url_launcher/url_launcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _logsType;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _logsType = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountsCubit>().loadAccounts().then((_) {
        _refreshData();
      });
    });
  }

  Future<void> _refreshData() async {
    final accountCount = context.read<AccountsCubit>().state;
    if (accountCount is AccountLoaded) {
      final userState = context.read<AuthCupit>().state;
      if (userState is! AuthenticatedWithUserState) return;
      final user = userState.user;
      if (user.totalAccounts == accountCount.accounts.length) return;
      context.read<AuthCupit>().authRepository.updateUserData(
        user.copyWith(totalAccounts: accountCount.accounts.length),
      );
    }
  }

  Future<void> refreshAccounts() async {
    await context.read<AccountsCubit>().loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthCupit>().signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final results = Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const AddAccountScreen()),
          );
          results.then((_) {
            refreshAccounts();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: BlocBuilder<AccountsCubit, AccountState>(
            builder: (context, state) {
              final user = context.read<AuthCupit>().state;
              if (state is AccountError) {
                return Center(child: Text(state.message));
              } else if (state is AccountLoading || user is InitialAuthState) {
                return Center(child: CircularProgressIndicator());
              }
              final accounts = state is AccountLoaded ? state.accounts : [];
              return Column(
                children: [
                  user is! AuthenticatedWithUserState
                      ? SizedBox.shrink()
                      : GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: [
                            buildStatCard(
                              'Total Accounts',
                              accounts.length.toString(),
                              Colors.blue,
                              Colors.white,
                            ),
                            buildStatCard(
                              'Total Revenue',
                              'R${accounts.fold<double>(0.0, (sum, account) => sum + (account.price ?? 0.0)).toStringAsFixed(2)}',
                              Colors.green,
                              Colors.white,
                            ),
                            buildStatCard(
                              'Total Customers',
                              accounts
                                  .fold(
                                    0,
                                    (sum, account) =>
                                        sum +
                                        (account.isAvailable == false ? 1 : 0),
                                  )
                                  .toString(),
                              Colors.orange,
                              Colors.white,
                            ),
                            buildStatCard(
                              'Total Sold Accounts',
                              accounts
                                  .fold(
                                    0,
                                    (sum, account) =>
                                        sum +
                                        (account.status == AccountStatus.sold
                                            ? 1
                                            : 0),
                                  )
                                  .toString(),
                              Colors.red,
                              Colors.white,
                            ),
                          ],
                        ),

                  state is! AccountLoaded
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.accounts.length,
                          itemBuilder: (context, index) {
                            return buildProductItem(state.accounts[index]);
                          },
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(
    String title,
    String value,
    Color color,
    Color textColor,
  ) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductItem(AccountModel account) {
    return Card(
      color: Colors.grey[200],
      child: InkWell(
        onTap: () async {
          if (account.status == AccountStatus.pending) {
            await locateAccountLogs(account);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Account is not pending logs')),
            );
          }
        },
        onLongPress: () async {
          await deleteAccount(account);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    account.imageUrls.isNotEmpty
                        ? account.imageUrls[0]
                        : 'https://via.placeholder.com/150',
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.accountTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Price: R${account.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        account.status == AccountStatus.available
                            ? 'Available'
                            : account.status == AccountStatus.sold
                            ? 'Sold'
                            : 'Pending',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> locateAccountLogs(AccountModel account) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Account Logs',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _email,
                decoration: InputDecoration(labelText: 'username'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<logsType>(
                style: TextStyle(color: Colors.black),
                initialValue: logsType.Google,
                items: logsType.values.map((logsType type) {
                  return DropdownMenuItem<logsType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (logsType? newValue) {
                  setState(() {
                    _logsType.text = newValue!.name;
                  });
                },
              ),

              // TextField(
              //   controller: _logsType,
              //   decoration: InputDecoration(labelText: 'Logs Type'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                final logsType = _logsType.text;
                if (email.isEmpty || password.isEmpty || logsType.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }
                final url = Uri.parse(
                  'https://wa.me/+27689014567?text=username: $email%0APassword: $password%0ALogs Type: $logsType %0AAccount ID: ${account.accountId}',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch WhatsApp')),
                  );
                  return;
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAccount(AccountModel account) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Delete Product',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to delete this image?',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await context.read<AccountsCubit>().deleteAccount(account);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}

enum logsType { Google, Facebook, Twitter, Apple }
