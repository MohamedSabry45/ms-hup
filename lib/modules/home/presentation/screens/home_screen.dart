import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/menu/presentation/widgets/menu_drawer.dart';
import 'package:reservation_workshop/modules/menu/presentation/cubits/business_location_cubit/business_location_cubit.dart';
import '../widgets/home_bottom_navigation_bar.dart';
import '../widgets/home_hero_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedBottomIndex = 0;
  int? _selectedCarId;
  String? _selectedCarLabel;
  bool _isGuest = false;
  bool _customerInfoRequested = false;

  @override
  void initState() {
    super.initState();
    _loadGuestMode();
    _loadSelectedCar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_customerInfoRequested) {
      _customerInfoRequested = true;
      context.read<CustomerInfoCubit>().load();
    }
  }

  Future<void> _loadGuestMode() async {
    final isGuest = await CacheHelper.getDataAsync<bool>(key: PrefKeys.kIsGuestMode) ?? false;
    if (!mounted) return;
    setState(() => _isGuest = isGuest);
  }

  Future<void> _loadSelectedCar() async {
    final id = await CacheHelper.getDataAsync<int>(key: PrefKeys.kSelectedCarId);
    final label = await CacheHelper.getDataAsync<String>(key: PrefKeys.kSelectedCarLabel);
    if (!mounted) return;
    setState(() {
      _selectedCarId = id;
      _selectedCarLabel = label?.trim();
    });
  }

  String _carLabel(CustomerCar car) {
    final plate = (car.plateNumber ?? '').trim();
    return '${car.device} ${car.model} ${plate.isEmpty ? '' : plate}'.trim();
  }






  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        drawer: BlocProvider<BusinessLocationCubit>(
          create: (_) => BusinessLocationCubit()..fetchBusinessLocation(),
          child: const MenuDrawer(),
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          selectedIndex: _selectedBottomIndex,
          onItemTapped: (index, route, arguments) {
            setState(() => _selectedBottomIndex = index);
            if (arguments != null) {
              Navigator.pushNamed(context, route, arguments: arguments);
            } else {
              Navigator.pushNamed(context, route);
            }
          },
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
                  builder: (context, state) {
                        String name = '';
                        if (!_isGuest && state is CustomerInfoSuccess) {
                          name = state.info.name.trim();
                        }
                        final greeting = _isGuest
                            ? 'home.greeting_guest'.tr()
                            : (name.isNotEmpty
                                ? 'home.greeting_named'.tr(args: [name])
                                : 'home.greeting'.tr());

                        final List<CustomerCar> cars = state is CustomerInfoSuccess
                            ? List<CustomerCar>.from(state.info.cars)
                            : <CustomerCar>[];
                        CustomerCar? selectedCar;
                        if (cars.isNotEmpty) {
                          if (_selectedCarId != null) {
                            for (final car in cars) {
                              if (car.id == _selectedCarId) {
                                selectedCar = car;
                                break;
                              }
                            }
                          }
                          selectedCar ??= cars.first;
                        }

                        String carLabel;
                        if (selectedCar != null) {
                          carLabel = _carLabel(selectedCar);
                        } else {
                          carLabel = (_selectedCarLabel ?? '').isNotEmpty
                              ? _selectedCarLabel!
                              : 'home.select_car'.tr();
                        }

                        return HomeHeroSection(
                          greeting: greeting,
                          carLabel: carLabel,
                          cars: cars,
                          selectedCarId: _selectedCarId,
                          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                          onCarSelected: (carId) async {
                            setState(() => _selectedCarId = carId);
                            if (carId != null) {
                              final car = cars.firstWhere((c) => c.id == carId);
                              final label = _carLabel(car);
                              await CacheHelper.saveData(key: PrefKeys.kSelectedCarId, value: carId);
                              await CacheHelper.saveData(key: PrefKeys.kSelectedCarLabel, value: label);
                              setState(() => _selectedCarLabel = label);
                            }
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
