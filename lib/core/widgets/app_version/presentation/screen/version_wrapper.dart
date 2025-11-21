import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/widgets/app_version/presentation/bloc/version_cupit.dart';
import 'package:game_vault_seller/core/widgets/app_version/presentation/bloc/version_state.dart';
import 'package:game_vault_seller/core/widgets/loading_widget.dart';
import 'package:game_vault_seller/features/auth/screens/widgets/auth_stream.dart';

import 'package:url_launcher/url_launcher.dart';

class VersionWrapper extends StatefulWidget {
  const VersionWrapper({super.key});

  @override
  State<VersionWrapper> createState() => _VersionWrapperState();
}

class _VersionWrapperState extends State<VersionWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VersionCupit>().checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionCupit, VersionState>(
      builder: (context, state) {
        log(
          'VersionWrapper State: $state ${(state is VersionLoaded) ? state.isUpToDate : null} ',
        );
        if (state is VersionLoading || state is VersionInitial) {
          return const Scaffold(body: LoadingWidget());
        } else if (state is VersionError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        final isUpToDate = state is VersionLoaded ? state.isUpToDate : false;

        log('Is app up to date? $isUpToDate');
        return Stack(
          children: [
            IgnorePointer(
              ignoring: !isUpToDate,
              child: Opacity(
                opacity: isUpToDate ? 1.0 : 0.5,
                child: const AuthStream(),
              ),
            ),
            if (!isUpToDate)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'A new version of the app is available!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://github.com/Wandilekubheka/game-vault-release/',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not launch update URL'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
