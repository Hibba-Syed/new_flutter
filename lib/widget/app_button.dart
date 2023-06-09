import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String? title;
  bool? isLoginButton;
  VoidCallback? onPress;
  bool? isLoading;

  AppButton(
      {Key? key,
      this.title,
      this.isLoading = false,
      this.isLoginButton = false,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLoginButton == false ? Colors.white : Colors.amber,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isLoginButton == false ? Colors.amber : Colors.amber),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: isLoading! ? false : true,
              child: Center(
                child: Text(
                  title ?? "button",
                  style: TextStyle(
                      color:
                          isLoginButton == false ? Colors.amber : Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
            Visibility(
              visible: isLoading!,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
