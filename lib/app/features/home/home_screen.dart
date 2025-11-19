// lib/app/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';

// Важно: если ты удалил event/state файлы, импортируй bloc.
// Если нет, оставь 'bloc/home_bloc.dart'
import 'bloc/home_block.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _home = getIt<HomeBloc>();
  void loadHome() => _home.add(HomeLoad());

  @override
  void initState() {
    loadHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _home,
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => _buildHomeInitial(),
            HomeLoadInProgress() => _buildHomeLoadInProgress(),
            HomeLoadSuccess() => _buildHomeLoadSuccess(state),
            HomeLoadFailure() => _buildHomeLoadFailure(state),
            // 'default' нужен, если event/state не в одном файле
            _ => _buildHomeInitial(), 
          };
        },
      ),
    );
  }

  Widget _buildHomeInitial() => SizedBox.shrink();

  Widget _buildHomeLoadInProgress() => AppProgressIndicator();

  Widget _buildHomeLoadSuccess(HomeLoadSuccess state) {
    final content = state.content;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Header',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 20),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: content.length,
            //
            // ВОТ ЗДЕСЬ ИСПРАВЛЕНИЕ:
            // Мы передаем 'content' в карточку
            //
            itemBuilder: (_, index) => ContentCard(
              content: content[index],
            ),
            separatorBuilder: (_, _) => 16.ph,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeLoadFailure(HomeLoadFailure state) {
    return AppError(
      description: state.exception.toString(),
      onTap: () => loadHome(),
    );
  }
}