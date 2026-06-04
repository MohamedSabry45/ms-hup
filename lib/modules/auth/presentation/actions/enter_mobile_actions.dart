import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/social_auth_cubit/social_auth_cubit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class EnterMobileActions {
  static Future<void> confirmRestoreDeletedAccount({
    required BuildContext context,
    required int userId,
    required String message,
    String? retryMobile,
    required Future<void> Function(int userId) restoreDeletedAccount,
    required Future<void> Function(String mobile) retryCheckPhone,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Restore account'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await restoreDeletedAccount(userId);
      final m = (retryMobile ?? '').trim();
      if (m.isNotEmpty) {
        await retryCheckPhone(m);
      }
    }
  }

  static Future<void> signInWithGoogle({
    required BuildContext context,
    required VoidCallback onStartLoading,
    required VoidCallback onStopLoading,
  }) async {
    try {
      onStartLoading();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        onStopLoading();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken ?? '';

      final socialCubit = SocialAuthCubit.get(context);
      await socialCubit.socialLogin(
        accessToken: accessToken,
        uniqueId: googleUser.id,
        email: googleUser.email,
        medium: 'google',
        name: googleUser.displayName,
      );
    } catch (e) {
      onStopLoading();
      Toasters.show(e.toString());
    }
  }

  static Future<void> signInWithApple({
    required BuildContext context,
    required VoidCallback onStartLoading,
    required VoidCallback onStopLoading,
  }) async {
    debugPrint('[APPLE_LOGIN] [A1] pressed');
    try {
      onStartLoading();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = appleCredential.identityToken ?? '';
      final authorizationCode = appleCredential.authorizationCode;
      final userIdentifier = appleCredential.userIdentifier ?? '';
      var email = appleCredential.email ?? '';

      if (email.isEmpty && identityToken.isNotEmpty) {
        try {
          final parts = identityToken.split('.');
          if (parts.length == 3) {
            final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
            final jwtData = jsonDecode(payload) as Map<String, dynamic>;
            email = jwtData['email']?.toString() ?? '';
            debugPrint('[APPLE_LOGIN] [A2] Extracted email from JWT: $email');
          }
        } catch (e) {
          debugPrint('[APPLE_LOGIN] [A2] Failed to parse JWT: $e');
        }
      }

      final fullName = <String?>[
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((e) => (e ?? '').trim().isNotEmpty).join(' ').trim();

      if (userIdentifier.trim().isEmpty || authorizationCode.trim().isEmpty) {
        throw Exception('Invalid Apple authorization code');
      }

      final socialCubit = SocialAuthCubit.get(context);
      await socialCubit.socialLogin(
        accessToken: '',
        uniqueId: userIdentifier,
        email: email,
        medium: 'apple',
        name: fullName.isNotEmpty ? fullName : null,
        identityToken: identityToken,
        authorizationCode: authorizationCode,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        onStopLoading();
        return;
      }
      onStopLoading();
      Toasters.show(e.toString());
    } catch (e) {
      onStopLoading();
      Toasters.show(e.toString());
    }
  }
}
