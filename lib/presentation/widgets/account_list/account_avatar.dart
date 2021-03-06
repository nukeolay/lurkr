import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lurkr/data/models/account.dart';

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    Key? key,
    required this.account,
  }) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(300.0),
      child: Container(
        width: 55.0,
        height: 55.0,
        decoration: account.savedProfilePic == ''
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(const Radius.circular(50.0)),
                border: Border.all(color: Colors.grey, width: 1.0),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(50.0)),
                border: Border.all(color: Colors.grey, width: 0.2),
                image: DecorationImage(
                  image: account.hasAnonymousProfilePicture
                      ? AssetImage('assets/default_avatar.png') as ImageProvider
                      : MemoryImage(Uint8List.fromList(account.savedProfilePic.codeUnits)),
                  fit: BoxFit.cover,
                ),
              ),
        child: account.savedProfilePic.toString() == ''
            ? Center(child: Icon(Icons.image_not_supported_outlined))
            : account.isPrivate
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          blurRadius: 7.0,
                          spreadRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                        )
                      ]),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2.0,
                          sigmaY: 2.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: Center(child: Icon(Icons.lock_outline_rounded, color: Colors.purple)),
                        ),
                      ),
                    ),
                  )
                : Text(''),
      ),
    );
  }
}
