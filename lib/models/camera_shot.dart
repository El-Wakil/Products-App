import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api_app/cubit/cubit/auth_cubit.dart';
import 'package:product_api_app/cubit/cubit/auth_state.dart';

class CameraShot extends StatelessWidget {
  const CameraShot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final authCubit = AuthCubit.get(context);
        return Column(
          children: [
            InkWell(
              onTap: () async {
                await authCubit.saveImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.white,
                ),
                height: 100,
                width: 100,
                child: authCubit.image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_rounded, size: 40),
                          Text(
                            "Add photo",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.file(
                          authCubit.image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
