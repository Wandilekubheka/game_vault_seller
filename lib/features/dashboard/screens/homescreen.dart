import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_cupit.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_state.dart';
import 'package:game_vault_seller/features/dashboard/data/account_model.dart';
import 'package:game_vault_seller/features/dashboard/screens/add_account.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/account_state.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/accounts_cupit.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
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
            _refreshData();
            setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: BlocBuilder<AccountsCubit, AccountState>(
            builder: (context, state) {
              final user =
                  context.read<AuthCupit>().state as AuthenticatedWithUserState;
              if (state is AccountLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AccountLoaded) {
                final accounts = state.accounts;
                return Column(
                  children: [
                    GridView.count(
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
                          'R${user.user.totalRevenue.toStringAsFixed(2)}',
                          Colors.green,
                          Colors.white,
                        ),
                        buildStatCard(
                          'Total Customers',
                          user.user.totalCustomers.toString(),
                          Colors.orange,
                          Colors.white,
                        ),
                        buildStatCard(
                          'Total Sold Accounts',
                          user.user.totalSales.toString(),
                          Colors.red,
                          Colors.white,
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        return buildProductItem(accounts[index]);
                      },
                    ),
                  ],
                );
              } else {
                return Center(child: Text('Failed to load accounts'));
              }
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
    return ListTile(
      leading: Icon(Icons.videogame_asset),
      title: Text(account.accountTitle),
      subtitle: Text('R${account.price.toStringAsFixed(2)}'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AddAccountScreen(existingAccount: account),
        //   ),
        // );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Delete Product',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
      },
    );
  }
}
