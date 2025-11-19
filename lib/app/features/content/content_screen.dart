// lib/app/features/content/content_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import 'bloc/content_bloc.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key, required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(contentId);

    return BlocProvider(
      create: (_) => getIt<ContentBloc>()
        ..add(ContentLoad(id: id ?? 0)),
      child: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state is ContentInitial || state is ContentLoadInProgress) {
            return const Scaffold(
              body: Center(child: AppProgressIndicator()),
            );
          } else if (state is ContentLoadFailure) {
            return Scaffold(
              body: Center(
                child: AppError(
                  description: state.exception.toString(),
                  onTap: () => context
                      .read<ContentBloc>()
                      .add(ContentLoad(id: id ?? 0)),
                ),
              ),
            );
          } else if (state is ContentLoadSuccess) {
            return _ContentView(contentState: state);
          } else {
            return const Scaffold(
              body: Center(child: AppProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({required this.contentState});

  final ContentLoadSuccess contentState;

  @override
  Widget build(BuildContext context) {
    final content = contentState.content;

    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                content.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            16.ph,
            Text(
              content.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.ph,
            Text(
              content.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}